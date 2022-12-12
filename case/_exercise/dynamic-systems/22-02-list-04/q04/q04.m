close all; clear all; clc;

%% Filter params

padding = 500;
passBand = [1000 2000]; % Pass band edge frequencies
stopBand = [passBand(1)-padding passBand(2)+padding]; % Stop band edge frequencies

fs = 10e3; % Sampling frequency
Rp = 01; % Max ripple in passing band [dB]
Rs = 60; % Min attenuation on stop band [dB]

Wp = passBand / (fs / 2); % Normalized passband edges
Ws = stopBand / (fs / 2); % Normalized stopband edges

%% Butterworth

[n, Wn] = buttord(Wp, Ws, Rp, Rs);
[num, den] = butter(n, Wn);
[h_butt, w] = freqz(num, den, 'whole');

figure;
pzmap(tf(num, den));
title('Butterworth');
grid on;

%% Eliptic
[n, Wn] = ellipord(Wp, Ws, Rp, Rs);
[num, den] = ellip(n, Rp, Rs, Wn);
[h_eliptic, w] = freqz(num, den, 'whole');

figure;
pzmap(tf(num, den));
title('Eliptic');
grid on;

%% Frequency responses

figure;
subplot(2, 1, 1);

hold on;
plot(w, abs(h_butt));
plot(w, abs(h_eliptic));
legend('Butterworth', 'Eliptic');
hold off;

title('Magnitude Response');
ylabel('$|H(e^{j \omega})|$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
grid on;

subplot(2, 1, 2);

hold on;
plot(w, phase(h_butt));
plot(w, phase(h_eliptic));
legend('Butterworth', 'Eliptic');
hold off;

title('Phase Response');
ylabel('$\theta(\omega))$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
grid on;