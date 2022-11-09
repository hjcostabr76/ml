close all; clear; clc;

b = [1/3 0];
a = [1 -5/6 1/6];
[h, w] = freqz(b, a, 'whole', 2001);

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
