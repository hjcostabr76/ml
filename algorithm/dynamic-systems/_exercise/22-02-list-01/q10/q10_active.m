clear; clc; close all;

%% Parameters
R1 = 40e3;
R2 = 10e3;
C1 = 250e-9;
C2 = 500e-9;

fMax = 5e3;
f = -fMax:100:fMax;

%% Set system
polyZeros = [-R2*C2 -1];
polyPoles = [R1*R2*C1*C2 R1*(C1 - C2) 0];

zeros = roots(polyZeros);
poles = roots(polyPoles);
transferFunction = tf(polyZeros, polyPoles);

H = freqs(polyZeros, polyPoles, f);
mag = abs(H);
phase = angle(H);
phasedeg = phase*180/pi;

%% Plot

% Zeros & poles
figure(1);
pzplot(transferFunction);
xlim([-225 225]);

% Bode
figure(2);
bode(transferFunction);
grid on;

% Magnitude response
figure(3);
subplot(2,1,1);
plot(f, mag);
ylabel('$|H(j \omega)|$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad/s)', 'Interpreter', 'latex');
title('Magnitude Response (linear)');
grid on;

% Phase response
subplot(2,1,2);
plot(f, phasedeg);
xlabel('$\omega$ (rad/s)', 'Interpreter', 'latex');
ylabel('$\theta(\omega)$ (deg)', 'Interpreter', 'latex');
title('Phase Response (linear)');
grid on;

% Impulse Response
figure(4);
subplot(2, 1, 1);
impulse(transferFunction);
grid on;

% Step Response
subplot(2, 1, 2);
step(transferFunction);
grid on;