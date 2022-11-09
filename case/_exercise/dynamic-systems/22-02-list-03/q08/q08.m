close all; clear; clc;

%% Time domain
N = 75; % Period (samples / second)
fs = 300;
Ts = 1/fs;
nPeriods = 1;

n = 0:(nPeriods*N - 1);
t = n * Ts;

x1 = 2*cos(2*pi*(32 / 300)*n + pi/3);
x2 = 3.4*cos(2*pi*(76 / 300)*n + pi/4);
x3 = 2.9*cos(2*pi*(88 / 300)*n + pi/5);
x4 = 1.1*cos(2*pi*(144 / 300)*n + 2*pi/7);
x = x1 + x2 + x3 + x4;

% % Plot
figure;

subplot(2, 1, 1);
hold on;
plot(t, x1);
plot(t, x2);
plot(t, x3);
plot(t, x4);

xlabel('time (s)');
ylabel('$x[nT]$', 'Interpreter', 'latex');
legend('$x_1(t)$', '$x_2(t)$', '$x_3(t)$', '$x_4(t)$', 'Interpreter', 'latex');

hold off;
grid on;

subplot(2, 1, 2);
plot(t, x);
xlabel('time (s)');
ylabel('$x[nT]$', 'Interpreter', 'latex');

%% Frequency domain
N1 = 2^nextpow2(N);
% N1 = N;
k = 0:N1-1;
f = fs*(k)/N1 - fs/2;
omega = 2*pi*(k)/N1 - pi;

X = fft(x, N1);
X_mag = abs(X); % Magnitude Spectrum
X_phase = phase(X); % Phase Spectrum


% Plot: Magnitude [Hz]
figure;

subplot(2, 1, 1);
stem(f, X_mag/N1);
title('Magnitude Response');
xlabel('f[kHz]');
ylabel('$|X(e^{j \omega})|$', 'Interpreter', 'latex');
grid on;

% Plot: Phase [Hz]
subplot(2, 1, 2);
stem(f, X_phase);
title('Phase Response');
xlabel('f[kHz]');
ylabel('$\theta(\omega) (rad)$', 'Interpreter', 'latex');
grid on;

% Plot: Magnitude [rad]
figure;

subplot(2, 1, 1);
stem(omega, X_mag/N1);
title('Magnitude Response');
xlabel('$\omega$ (rad/S)', 'Interpreter', 'latex');
ylabel('$|X(n)|$', 'Interpreter', 'latex');
xlim([-3.5 3.5]);
grid on;

% Plot: Phase [Hz]
subplot(2, 1, 2);
stem(omega, X_phase);
title('Phase Response');
xlabel('$\omega$ (rad/S)', 'Interpreter', 'latex');
ylabel('$\theta(n)$', 'Interpreter', 'latex');
xlim([-3.5 3.5]);
grid on;
