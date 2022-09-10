clear; clc; close all;

syms omega;
s = i*omega;

R1 = 40e3;
R2 = 10e3;
C1 = 250e-9;
C2 = 500e-9;

fMax = 5e3;
f = -fMax:100:fMax;

H_jOmega = -(R2*C2 + 1) / (s*R2*C1*C2 - C2);
H = arrayfun(@(fi) mag2db(abs(subs(H_jOmega, [omega], fi))), f);
theta = arrayfun(@(fi) phase(subs(H_jOmega, [omega], fi)), f);

% Magnitude
subplot(2, 1, 1);
plot(f, H);
xlabel('Frequency (Hz)');
ylabel('$|X{j \omega}| dB$', 'Interpreter', 'latex');
title('Frequency Domain (magnitude spectrum)');
grid on;

% Phase
subplot(2, 1, 2);
plot(f, theta);
xlabel('Frequency (Hz)');
ylabel('$\theta(\omega) deg$', 'Interpreter', 'latex');
title('Frequency Domain (phase spectrum)');
grid on;
