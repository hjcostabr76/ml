clear; clc; close all;

syms omega;
s = i*omega;

R1 = 1e3;
R2 = 250;
L = 50e-3;
C = 1e-6;

fMax = 5e3;
f = -fMax:100:fMax;

H_jOmega = (R2 + s*L) / (R1 + R2 + s*L + R1*R2*s*C + s^2*R1*L*C);
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
