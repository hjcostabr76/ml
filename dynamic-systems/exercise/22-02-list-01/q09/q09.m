clc; clear; close all;

%% Set system
polyZeros = [1 0 1 0];
polyPoles = [1 2 4 3 1.25];

zeros = roots(polyZeros);
poles = roots(polyPoles);

w = logspace(-1, 1);
H = freqs(polyZeros, polyPoles, w);
mag = mag2db(abs(H));
phase = angle(H);
phasedeg = phase*180/pi;

%% Plot

% Zeros & poles
figure(1);
pzplot(tf(polyZeros, polyPoles));
xlim([-.7 .2]);
ylim([-1.7 1.7]);

% Magnitude response
figure(2);
subplot(2,1,1);
loglog(w, mag);
grid on;
ylabel('$|H(j \omega)| (dB)$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad/s)', 'Interpreter', 'latex');

% Phase response
subplot(2,1,2);
semilogx(w, phasedeg);
xlabel('$\omega$ (rad/s)', 'Interpreter', 'latex');
ylabel('$\theta(\omega)$ (deg)', 'Interpreter', 'latex');
grid on;