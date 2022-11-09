close all; clear; clc;

b = [.1616 .3026 .1616];
a = [1 -.6754 .3775];

fs = 1;
H = tf(b, a, fs);

%% Unit sample response
figure;
impz(b, a);
grid on;

%% Zero pole map
figure;
pzmap(H);

%% Frequency response

% Denormalized
[h, w] = freqz(b, a, 'whole');
h = fftshift(h);
w = w - pi;

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

% Normalized
figure;
freqz(b, a, 'whole');
grid on;