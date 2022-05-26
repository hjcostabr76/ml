

%% Generate PRBS
nSamples = 500;
prbsBitsLength = 4;
prbsInterval = 4; % Interval between bits
prbsBits = rand(1, prbsBitsLength) > 0.5;

prbs = getPRBS(nSamples, prbsBitsLength, prbsInterval, prbsBits);

% %% Model ARX (with no noise)
u = prbs;

% Coeficients
a1 = 1.5; a2 = -0.7;
b1 = 1; b2 = 0.5;
theta = [a1 a2 b1 b2]

% Initial Conditions
y = zeros(nSamples, 1);
psi = zeros(nSamples, 4);

y(1:2) = 0;
psi(1:2, :) = 0;

% Calculate
for k = 3:length(u)
    psi(k, :) = [y(k - 1) y(k - 2) u(k - 1) u(k - 2)];
    y(k) = dot(theta, psi(k, :));
end

%% Tests 01

% Test 01.1
pointsT1 = [5 6 7 8];
psiTest11 = psi(pointsT1, :);
yTest11 = y(pointsT1);
% thetaHat11 = pinv(transpose(psiTest11) * psiTest11) * transpose(psiTest11) * yTest11
thetaHat11 = inv(psiTest11) * yTest11;

% Test 01.2
pointsT2 = [205 206 207 208];
psiTest12 = psi(pointsT2, :);
yTest12 = y(pointsT2);
thetaHat12 = inv(psiTest12) * yTest12;

%% Model ARX (+ white noise)

% White noise
yStdDev = 2;%std(y);
noiseStdDev = .05*yStdDev;
noiseMean = 0;
noise = noiseMean + noiseStdDev.*randn(1, nSamples);

u = noise + prbs;

% Initial conditions
yNoise = zeros(nSamples, 1);
psiNoise = zeros(nSamples, 4);

yNoise(1:2) = 0;
psiNoise(1:2, :) = 0;

% Calculate
for k = 3:length(u)
    psiNoise(k, :) = [yNoise(k - 1) yNoise(k - 2) u(k - 1) u(k - 2)];
    yNoise(k) = dot(theta, psiNoise(k, :));
end

%% Tests 02

% Test 02.1
psiTest21 = psiNoise(pointsT1, :);
yTest21 = y(pointsT1);
% thetaHat21 = inv(psiTest21) * yTest21;

% Test 02.2
psiTest22 = psiNoise(pointsT2, :);
yTest22 = y(pointsT2);
% thetaHat22 = inv(psiTest22) * yTest22;

%% Plot
figure; hold on;
plot(y, 'b');
plot(yNoise, 'r');
title('ARX');
legend('No noise', 'Gaussian noise');
hold off;

%% Estimate by minimum squares
thetaHat3 = pinv(psi) * y;
