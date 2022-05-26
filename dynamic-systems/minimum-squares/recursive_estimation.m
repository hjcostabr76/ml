clear; close all; clc;

%% Generate PRBS
nSamples = 401;
prbsBitsLength = 8;
prbsInterval = 2; % Interval between bits

u = getPRBS(nSamples, prbsBitsLength, prbsInterval);

figure(1);
grid on;
plot(u, 'b');
ylim([-0.5, 1.5]);
xlim([0, nSamples]);
title("PRBS");

%% Generate Transfer Function: K.e^(-theta.s) / (tau.s + 1)
K = 3.38;
theta = 10;
tau = 11;

% Simulate for PRBS input
G1 = tf(K, [tau 1], 'InputDelay', theta);
y = lsim(G1, u, 1:nSamples);

figure(2);
plot(y, 'r');
xlim([0, nSamples]);
grid on;
title("Response to PRBS");

%% Estimate theta by inspecting FCC
figure(3);
hold on;

[t, rUY, confidenceLevel, dummy] = myccf([y u'], nSamples, 1, 0);

plot(t, rUY, 'k');
plot(t, confidenceLevel * ones(nSamples), ':k');
plot(t, -confidenceLevel * ones(nSamples), ':k');

ylim([-0.4, 0.8])
title('FCC Input \leftrightarrow output');
hold off;

%% Estimate tau and K by minimum squares

% Initial Conditions
psi = eye(2) * 10^6;
tS = 1;
t0 = 10;

theta(1:2, t0-1) = [1 - (1 / 9); 1 * 2/1];

y = y(t0:nSamples);
u = u(1:nSamples-t0);
y = y - mean(y);
u = u - mean(u);

% Reccursive algorithim
lambda = 0.998; % Fator de esquecimento

for k = t0:length(y)
   aux1 = [y(k - 1); u(k - 1)];
   aux2 = psi*aux1 / (aux1'*psi*aux1 + lambda);
   theta(:, k) = theta(:, k - 1) + aux2*(y(k) - aux1'*theta(:, k - 1));
   psi = (psi - (psi*aux1*aux1'*psi) / (aux1'*psi*aux1 + lambda)) / lambda;
end

[a b] = size(theta);

for k = 1:b   
   tau(k) = -tS / (theta(1, k) - 1);
   gain(k) = tau(k) * theta(2, k) / tS;
end

figure(4)
subplot(211);
plot(tS:tS:(b - 2*t0 + 2)*tS, tau(t0-1:b-t0), 'g');
title('Time Constant \tau');

subplot(212)
plot(tS:tS:(b - 2*t0 + 2)*tS, gain(t0 - 1:b - t0), 'c');
title('Gain K');