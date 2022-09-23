clear; clc; close all;

%% Parameters
N = 24;

fs = 4;
f0 = 1 / 6;
T0 = 1 / f0;

%% Set values

% Time domain
t = 0:1/fs:(T0 - 1/fs);
x = [1 1 1 1 0.8 0.6 0.4 0.2 0 0 0 0 0 0 0 0 0.2 0.4 0.6 0.8 1 1 1 1];

% Frequency domain
f = fs*(0:(N - 1)) / N; % Frequency axis
X = fft(x, N);
X_mag = abs(X); % Magnitude Spectrum
X_phase = phase(X); % Phase Spectrum

% Harmonics summation approximation
nHarmonics = 12;
amplitudes = X_mag((1 + N/2):end);
phases = X_phase((1 + N/2):end);

harmonics = zeros(nHarmonics, N);
for i = 1:nHarmonics
    harmonics(i, :) = getSine(amplitudes(i), f0, fs, (pi / 2) + phases(i), N); % Add 90deg to turn sine into cosine
end

xHat = sum(harmonics, 1);

%% Plot time domain graphs
figure(1);

% Original signal
subplot(2, 1, 1);
plot(t, x, '-O');
xlabel('time (s)');
ylabel('x(t)');
ylabel('$x(t)$', 'Interpreter', 'latex');
title('Original signal');
ylim([-.2 1.3]);
grid on;

% Harmonics
subplot(2, 1, 2);
hold on;

plot(t, xHat, '-o');
for i = 1:nHarmonics
    plot(t, harmonics(i, :));
end

xlabel('time (s)');
ylabel('$\hat{x(t)}$', 'Interpreter', 'latex');
title('Harmonics summation approximated signal')

hold off;
grid on;

%% Plot frequency domain graphs
figure(2);

% Magnitude
subplot(2, 1, 1);
plot(f, (X_mag / N), '-o'); % Plotting magnitude after normalization
xlabel('Frequency (Hz)');
ylabel('$X{j \omega}$', 'Interpreter', 'latex');
title('Frequency Domain (magnitude spectrum)');
ylim([-.1 .6]);
grid on;

% Phase
subplot(2, 1, 2);
plot(f, X_phase, '-o');
xlabel('Frequency (Hz)');
ylabel('$\Im \{ X{j \omega} \}$', 'Interpreter', 'latex');
title('Frequency Domain (phase spectrum)');
grid on;
