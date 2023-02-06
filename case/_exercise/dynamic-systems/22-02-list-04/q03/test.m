close all; clear all; clc;

color=[0.8500 0.3250 0.0980];
n_points = 512;


%% Filter params

Rp = .3; % Max ripple in passing band [dB]
Rs = 30; % Min attenuation on stop band [dB]

% fs = 2*pi*1e3; % Sampling frequency
fs = 10e3; % Sampling frequency
T = 1 / fs;

% % omega_p = .5*pi / fs;
% % omega_s = .6*pi / fs;
% omega_p = deg2rad(.5*pi) / deg2rad(fs);
% omega_s = deg2rad(.6*pi) / deg2rad(fs);

% Wp = deg2rad(.5*pi) / fs;
% Ws = deg2rad(.6*pi) / fs;

omega_p = .5*pi;
omega_s = .6*pi;
Ws = 2/T * tan(omega_s / 2) / fs;
Wp = 2/T * tan(omega_p / 2) / fs;

%% Elliptic: Analog filter
[n, Wn] = ellipord(Wp, Ws, Rp, Rs, 's');
[z, p, k] = ellip(n, Rp, Rs, Wn, 's');
[num, den] = zp2tf(z,p,k);

% Zero pole map
figure;
pzplot(tf(num, den));
title('Eliptic: Zero Pole');

% Magnitude response
figure;
subplot(2, 1, 1);
% freqs(num, den, n_points);
[h, w] = freqs(num, den, n_points);

% plot(w / (2*pi), mag2db(abs(h)));
plot(w, mag2db(abs(h)));
xline(Wp, Color=color);
grid;

title('Magnitude Response');
legend(["Magnitude response" "Cutoff frequency"]);
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
ylabel("Magnitude (dB)");
% ylabel('$|H(e^{j \omega})|$', 'Interpreter', 'latex');
grid on;

% Phase response
subplot(2, 1, 2);
plot(w, phase(h));

title('Phase Response');
ylabel('$\theta(\omega))$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
grid on;

%% Elliptic: Digital filter
[zd, pd, kd] = bilinear(z, p, k, fs, Wp);
[zd, pd, kd] = bilinear(z, p, k, fs);
[hd, fd] = freqz(zp2sos(zd, pd, kd), [], fs);
[numd, dend] = zp2tf(z, p, k);
Hz = tf(numd, dend, T);

% Zero pole map
figure;
pzplot(Hz);
title('Elliptic (digital): Zero pole map');

% Magnitude response
figure;
subplot(2, 1, 1);
plot(fd, mag2db(abs(hd)));
xline(Wp, Color=color);

title('Elliptic (digital): Magnitude Response');
legend(["Magnitude response" "Cutoff frequency"]);
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
ylabel("Magnitude (dB)");
grid;

subplot(2, 1, 2);
plot(w, phase(hd));

title('Phase Response');
ylabel('$\theta(\omega))$', 'Interpreter', 'latex');
xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
grid;