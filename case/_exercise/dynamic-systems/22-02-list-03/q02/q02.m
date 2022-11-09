close all; clear; clc;

N = 40; % Period (samples / second)
fs = 2e3;
Ts = 1/fs;
nPeriods = 3;

n = 0:(nPeriods*N - 1);
t = n * Ts;
xn = .8*cos(.1*pi*n + pi/3) + 1.3*sin(.25*n + pi/6);

subplot(2, 1, 1);
plot(t, xn);
xlabel('time (s)');
ylabel('$x[nT]$', 'Interpreter', 'latex');
title('Time');
grid on;

subplot(2, 1, 2);
plot(n, xn);
xlabel('sample (n)');
ylabel('$x[n]$', 'Interpreter', 'latex');
title('Sample');
grid on;