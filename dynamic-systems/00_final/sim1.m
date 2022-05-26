clc; clear; close all;

nFig = 0;

%
%======================================================================
% 
%% Set 2nd order underdamped stable system
% 
% - Characteristic Eq:
% s^2 + 2.zeta.omegaN.s + omegaN^2
% 
% - General equation: 2nd Order systems:
% omegaN^2 / [characteristic eq]
%
% - Stability -> System is stable if roots of characteristic eq. are;
%   s1, s2 < 0
%
% - Underdamping -> System will be underdamped if:
%   0 < zeta < 1
%
%======================================================================
%

% Set transfer function
gain = 1; zeta = .1; omegaN = 10;
H0 = get2ndOrderSystem(gain, zeta, omegaN);

% -----------------------------------------------------------------------
% Pulse response shows that the system is underdamped by the shape of the curve

amplitude = 1;
tBegin = 0;
tEnd = 30;

u = getSignal(amplitude, tBegin, tEnd, 2); % Impulse
t = 1:1:tEnd;
y = lsim(H0, u, t);

nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(t, u, 'r'); xlabel('t(s)'); ylabel('y(t)');
plot(t, y, '-ob'); xlabel('t(s)'); ylabel('y(t)');
title('Resposta ao Impulso');
legend('Input', 'Output');
hold off;

% -----------------------------------------------------------------------
% Step response shows that the system is stable because it's limited

u = getSignal(amplitude, tBegin, tEnd, 2); % Impulse
t = 1:1:tEnd;
y = lsim(H0, u, t);

u = getSignal(amplitude, tBegin, tEnd, 1); % Step
subplot(212);
hold on;
plot(t, u, 'r'); xlabel('t(s)'); ylabel('y(t)');
plot(t, y, '-ob'); xlabel('t(s)'); ylabel('y(t)');
title('Resposta ao Degrau')
legend('Input', 'Output');
hold off;

saveas(gcf, getFilePath('01-01-continuous-pulse-step'));

%
%======================================================================
%
%% Turn continuous time system into discrete time system
%
% H =
%
%       1.258 z + 1.079
%   -----------------------
%   z^2 + 0.6665 z + 0.6703
% 
% Sample time: 0.2 seconds
% Discrete-time transfer function.
%
%======================================================================
%

ts = .05;
H = c2d(H0, ts, 'zoh');

nFig = nFig + 1; figure(nFig);
step(H0, '-b', H, '--r');
saveas(gcf, getFilePath('01-02-discrete-step'));

a1 = .6665; a2 = .6703;
b1 = 1.258; b2 = 1.079;

%
%======================================================================
%% Apply PRBS
%======================================================================
%

% Generate PRBS
tMax = 100;
nSamples = tMax / ts;
prbsBitsLength = 10;
prbsInterval = 3; % Interval between bits

% u=getPRBS(2000, 10, 3);
u = getPRBS(nSamples, prbsBitsLength, prbsInterval);

% Generate clean response
t = ts:ts:tMax;
y = lsim(H, u, t);

% Generate response with noise
muE = 0;
sigmaE = getBestSigmaE(std(y));
e = muE + sigmaE.*randn(length(y),1);

ym = zeros([length(y), 1]);
for k = 3:length(y)
    ym(k) = -a1*ym(k - 1) -a2*ym(k - 2) + b1*u(k - 1) + b2*u(k - 2)+ e(k);
end

% Plot
nFig = nFig + 1; figure(nFig);
subplot(311);
plot(u(1:tMax));
grid on;
title('PRBS Input');
xlabel('time (s)'); ylabel('signal');

subplot(312);
plot(y(1:tMax));
title('Output (clean)');
grid on;
xlabel('time (s)'); ylabel('signal');

subplot(313);
plot(ym(1:tMax));
grid on;
title('Output (with noise)');
xlabel('time (s)'); ylabel('signal');

saveas(gcf, getFilePath('01-03-discrete-prbs'));

%
%======================================================================
%% Estimate system parameters
%======================================================================
%

%% Split data for identification X Validation

kId = 500;

u = u - mean(u); 
y = y - mean(y); 
ym = ym - mean(ym);

uId = u(1:kId);
yId = y(1:kId);
yIdm = ym(1:kId);

uTest = u(kId+1:end);
yTest = y(kId+1:end);
tTest = t(kId+1:end);
ymTest = ym(kId+1:end);

%% Estimate params for the clean system
psi0 = eye(4)*10^6;
psi = psi0;
ini = 3; 

theta(:, ini - 1) = [1; 1; 1; 1]; 
lambda = 0.998; % Fator de esquecimento

for k = ini:length(yId)
   psiK = [yId(k - 1); yId(k - 2); uId(k - 1); uId(k - 2)];
   K_k = psi*psiK / ( psiK'*psi*psiK + lambda); 
   theta(:,k) = theta(:, k - 1) + K_k*( yId(k) - psiK'*theta(:, k - 1) ); 
   psi = ( psi - psi*psiK*psiK'*psi / ( psiK'*psi*psiK + lambda ) ) / lambda; 
end

[a, b] = size(theta); 

params = theta(:, end);
a1Hat = params(1);
a2Hat = params(2);
b1Hat = params(3);
b2Hat = params(4);

%% Estimate params for the system with noise
psi = psi0;
thetaNoise(:, ini - 1) = [1; 1; 1; 1]; 
for k = ini:length(yIdm)
   psiK = [yIdm(k - 1); yIdm(k - 2); uId(k - 1); uId(k - 2)]; 
   K_k = psi*psiK / ( psiK'*psi*psiK + lambda ); 
   thetaNoise(:,k) = thetaNoise(:, k - 1) + K_k*( yIdm(k) - psiK'*thetaNoise(:, k - 1) ); 
   psi = (psi - psi*psiK*psiK'*psi / ( psiK'*psi*psiK + lambda )) / lambda; 
end

[am, bm] = size(thetaNoise); 

paramsNoise = thetaNoise(:, end);
a1NoiseHat = paramsNoise(1);
a2NoiseHat = paramsNoise(2);
b1NoiseHat = paramsNoise(3);
b2NoiseHat = paramsNoise(4);

%
%======================================================================
%% Validate Estimation
%======================================================================
%

%% Validate estimation for clean system
z = tf('z', ts); 
HHat = (b1Hat * z^1 + b2Hat) / (z^2 - a1Hat * z^1 - a2Hat);
yHat = lsim(HHat, uTest, tTest);

% Compare one against each other
nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(yHat);
plot(yTest, '--m');
grid on;

title('Validation (clean output)');
legend('Estimation', 'Validation');

subplot(212);
plot(yHat - yTest, 'r');
grid on;
title('Validation (error)');

saveas(gcf, getFilePath('01-04-validation-clean'));

%% Validate estimation for system with noise
HmHat = (b1NoiseHat * z^1 + b2NoiseHat) / (z^2 - a1NoiseHat * z^1 - a2NoiseHat);
ymHat = lsim(HHat, uTest, tTest); 

% Compare one against each other
nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(ymTest);
plot(ymHat, '--m');
grid on;

title('Validation (output with noise)');
legend('Estimation', 'Validation');

subplot(212);
plot(ymHat - ymTest, 'r');
grid on;
title('Validation (error)');

saveas(gcf, getFilePath('01-05-validation-noise'));

%% Compare step responses

step = zeros([length(tTest), 1]);
step(500:end) = 1;

yStep = lsim(H, step, tTest);
yHatStep = lsim(HHat, step, tTest);
ymHatStep = lsim(HmHat, step, tTest);

nFig = nFig + 1; figure(nFig);
hold on;
plot(tTest(480:520)', yStep(480:520), '-r');
plot(tTest(480:520)', yHatStep(480:520), ':ob');
plot(tTest(480:520)', ymHatStep(480:520), ':ok');
grid on; 
hold off; 

title('Step response (2nd Order)');
legend('Real', 'Clean sytem estimation', 'System with noise estimation');

saveas(gcf, getFilePath('01-06-validation-step'));

%
%======================================================================
%% Estimation for 1st Order
%======================================================================
%

%% Recursive estimation for signal without noise
clear theta thetaNoise yHat ymHat
psi = eye(2)*10^6; 
ini = 3; 
theta(:, ini - 1) = [1; 1]; 
lambda = 0.998; 
for k = ini:length(yId)
   psi_k = [yId(k-1); uId(k-1)]; 
   K_k = (psi*psi_k)/(psi_k'*psi*psi_k+lambda); 
   theta(:,k) = theta(:,k-1)+K_k*(yId(k)-psi_k'*theta(:,k-1)); 
   psi = (psi-(psi*psi_k*psi_k'*psi)/(psi_k'*psi*psi_k+lambda))/lambda; 
end
[a, b] = size(theta); 
params = theta(:,end); 

HHat = (params(2)) / (z^1 - params(1));
yHat = lsim(HHat, uTest, tTest);

nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(yHat);
plot(yTest); 
grid on;
title('Validation of output (1st order signal without noise)');

subplot(212); 
plot(yHat - yTest);
title('Error  (1st order signal without noise)'); 
grid on; 
hold off; 

saveas(gcf, getFilePath('01-07-order-01-validation'));

%% Recursive estimation for signal with noise
psi = eye(2)*10^6; 
thetaNoise(:, ini - 1) = [1; 1]; 
for k = ini:length(yIdm)
   psi_k = [yIdm(k-1); uId(k-1)]; 
   K_k = (psi*psi_k)/(psi_k'*psi*psi_k+lambda); 
   thetaNoise(:,k) = thetaNoise(:,k-1)+K_k*(yIdm(k)-psi_k'*thetaNoise(:,k-1)); 
   psi = (psi-(psi*psi_k*psi_k'*psi)/(psi_k'*psi*psi_k+lambda))/lambda; 
end

[am, bm] = size(thetaNoise); 
paramsNoise = thetaNoise(:,end); 

HmHat = (params(2)) / (z^1 - params(1));
ymHat = lsim(HmHat, uTest, tTest); 

nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(ymHat); 
plot(ymTest); 
title('Validation of output (1st order signal with noise)');
grid on;

subplot(212); 
plot(ymHat - ymTest);
grid on; 
title('Error (1st order signal with noise)'); 
hold off;

saveas(gcf, getFilePath('01-08-order-01-validation-noise'));

%% Compare step responses

step = zeros([length(tTest), 1]);
step(500:end) = 1;

yStep = lsim(H, step, tTest);
yHatStep = lsim(HHat, step, tTest);
ymHatStep = lsim(HmHat, step, tTest);

nFig = nFig + 1; figure(nFig);
hold on;
plot(tTest(480:520)', yStep(480:520), '-r');
plot(tTest(480:520)', yHatStep(480:520), ':ob');
plot(tTest(480:520)', ymHatStep(480:520), ':ok');
grid on; 
hold off; 

title('Step response (1st Order)');
legend('Real', 'Clean sytem estimation', 'System with noise estimation');

saveas(gcf, getFilePath('01-09-order-01-validation-step'));

%
%======================================================================
%% Estimation for 3rd Order
%======================================================================
%

%% Recursive estimation for signal without noise
clear theta thetaNoise yHat ymHat
psi = eye(6)*10^6; 
ini = 4; 
theta(:, ini - 1) = [1; 1; 1; 1; 1; 1];
lambda = 0.998;

for k = ini:length(yId)
   psi_k = [yId(k-1); yId(k-2); yId(k-3); uId(k-1); uId(k-2); uId(k-3)]; 
   K_k = (psi*psi_k)/(psi_k'*psi*psi_k+lambda); 
   theta(:,k) = theta(:,k-1)+K_k*(yId(k)-psi_k'*theta(:,k-1)); 
   psi = (psi-(psi*psi_k*psi_k'*psi)/(psi_k'*psi*psi_k+lambda))/lambda; 
end
[a, b] = size(theta); 
params = theta(:,end);

HHat = (params(4) * z^2 + params(5) * z^1 + params(6)) / (z^3 - params(1) * z^2 - params(2) * z^1 - params(3));
yHat = lsim(HHat, uTest, tTest);

nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(yHat);
plot(yTest); 
grid on;
title('Validation of output (3rd order signal without noise)');

subplot(212); 
plot(yHat - yTest);
title('Error  (3rd order signal without noise)'); 
grid on; 
hold off;

saveas(gcf, getFilePath('01-10-order-03-validation'));

%% Recursive estimation for signal with noise
psi = eye(6)*10^6; 
thetaNoise(:, ini - 1) = [1; 1; 1; 1; 1; 1];

for k = ini:length(yIdm)
   psi_k = [yId(k-1); yId(k-2); yId(k-3); uId(k-1); uId(k-2); uId(k-3)]; 
   K_k = (psi*psi_k)/(psi_k'*psi*psi_k+lambda); 
   thetaNoise(:,k) = thetaNoise(:,k-1)+K_k*(yIdm(k)-psi_k'*thetaNoise(:,k-1)); 
   psi = (psi-(psi*psi_k*psi_k'*psi)/(psi_k'*psi*psi_k+lambda))/lambda; 
end
[am, bm] = size(thetaNoise);
paramsNoise = thetaNoise(:, end);

HmHat = (params(4) * z^2 + params(5) * z^1 + params(6)) / (z^3 - params(1) * z^2 - params(2) * z^1 - params(3));
ymHat = lsim(HmHat, uTest, tTest);

nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(ymHat); 
plot(ymTest); 
title('Validation of output (3rd order signal with noise)');
grid on;

subplot(212); 
plot(ymHat - ymTest);
grid on; 
title('Error (3rd order signal with noise)'); 
hold off;

saveas(gcf, getFilePath('01-11-order-03-validation-noise'));

%% Compare step responses

step = zeros([length(tTest), 1]);
step(500:end) = 1;

yStep = lsim(H, step, tTest);
yHatStep = lsim(HHat, step, tTest);
ymHatStep = lsim(HmHat, step, tTest);

nFig = nFig + 1; figure(nFig);
hold on;
plot(tTest(480:520)', yStep(480:520), '-r');
plot(tTest(480:520)', yHatStep(480:520), ':ob');
plot(tTest(480:520)', ymHatStep(480:520), ':ok');
grid on; 
hold off; 

title('Step response (3rd Order)');
legend('Real', 'Clean sytem estimation', 'System with noise estimation');

saveas(gcf, getFilePath('01-12-order-03-validation-step'));