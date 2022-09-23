clear; clc; close;

%% Parameters
N = 20;
fs = 500e3;
f0 = 25e3;
T0 = 1 / f0;

timeStep = T0 / N;
t = 0:timeStep:(T0 - timeStep); % Continuous time
k = 0:(N - 1); % Discrete time

%% Build components
x0 = 2.8 * ones(1, N);
x1 = getSine(6, f0, fs, (pi / 2) + (-pi / 4), N); % Add 90deg to turn sine into cosine
x2 = getSine(2.6, 2*f0, fs, (pi / 2) + (3*pi / 8), N); % Add 90deg to turn sine into cosine
x = x0 + x1 + x2;

%% Plot (discrete)
subplot(1, 2, 1);

hold on;
plot(k, x0, '-x');
plot(k, x1, '-x');
plot(k, x2, '-x');
plot(k, x, '-o');

title('Discrete Time');
xlabel('n');
ylabel('x[n]');
legend('DC Component', '1st Harmonic', '2nd Harmonic', 'signal');
grid on;

hold off;

%% Plot (continuous)
subplot(1, 2, 2);

hold on;
plot(t, x0, '-x');
plot(t, x1, '-x');
plot(t, x2, '-x');
plot(t, x, '-o');

title('Continuous Time');
xlabel('t');
ylabel('x(t)');
legend('DC Component', '1st Harmonic', '2nd Harmonic', 'signal');
grid on;

hold off;
