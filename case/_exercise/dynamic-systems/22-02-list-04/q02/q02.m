close all; clear all; clc;

%% Filter params

Rp = 1; % Max ripple in passing band [dB]
Rs = 15; % Min attenuation on stop band [dB]

% Digital frequencies in Herts
fs = 10e3; % Sampling frequency
omega_p = 2*pi*1e3 / fs;
omega_s = 2*pi*1.5e3 / fs;

% Digital frequencies in radians
ws = pi*fs / 180;
omega_p = pi*omega_p / 180;
omega_s = pi*omega_s / 180;

T = 1 / ws;
Wp = 2/T * tan(omega_p / 2) / ws;
Ws = 2/T * tan(omega_s / 2) / ws;

%% Butterworth: Analog
[n, Wn] = buttord(Wp, Ws, Rp, Rs);
[num, den] = butter(n, Wn);
Hs = tf(num, den);

figure;
pzmap(Hs);
title('Butterworth: Analog');

% Frequency responses
[h_butt, w] = freqz(num, den, 'whole');
h_butt = fftshift(h_butt);
w = w - pi;

figure;
subplot(2, 1, 1);

hold on;
plot(w, abs(h_butt));
hold off;

title('Magnitude Response');
ylabel('$|H(e^{j \omega})|$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
grid on;

subplot(2, 1, 2);

hold on;
plot(w, phase(h_butt));
hold off;

title('Phase Response');
ylabel('$\theta(\omega))$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
grid on;

%% Butterworth: Digital
[numd, dend] = bilinear(num, den, Wn);
Hz = tf(numd, dend, T);

figure;
pzmap(Hz);
title('Butterworth: Digital');

% Frequency responses
[h_butt, w] = freqz(num, den, 'whole');
h_butt = fftshift(h_butt);
w = w - pi;

figure;
subplot(2, 1, 1);

hold on;
plot(w, abs(h_butt));
hold off;

title('Magnitude Response');
ylabel('$|H(e^{j \omega})|$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
grid on;

subplot(2, 1, 2);

hold on;
plot(w, phase(h_butt));
hold off;

title('Phase Response');
ylabel('$\theta(\omega))$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
grid on;