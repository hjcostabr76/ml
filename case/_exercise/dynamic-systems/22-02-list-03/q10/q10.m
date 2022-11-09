close all; clear; clc;

b = [1/3 0];
a = [1 -5/6 1/6];
[h, w] = freqz(b, a, 'whole');

%% Response in radians
figure;
subplot(2, 1, 1);
plot(w, abs(h));
title('Magnitude Response');
ylabel('$|H(e^{j \omega})|$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
grid on;

subplot(2, 1, 2);
plot(w, phase(h));
title('Phase Response');
ylabel('$\theta(\omega))$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
grid on;

%% Response in Hertz
figure;

fs = 5;
f = (fs*w) / (2*pi);

subplot(2, 1, 1);
plot(f, abs(h));
title('Magnitude Response');
ylabel('$|H(f)|$', 'Interpreter', 'latex');
xlabel('f (kHz)');
grid on;

subplot(2, 1, 2);
plot(f, phase(h));
title('Phase Response');
ylabel('$\theta(f))$', 'Interpreter', 'latex');
xlabel('f (kHz)');
grid on;
