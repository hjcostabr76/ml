close all; clear all; clc;

%% Filter params

Rp = .3; % Max ripple in passing band [dB]
Rs = 30; % Min attenuation on stop band [dB]

fs = 1e3; % Sampling frequency
T = 1 / fs;

% omega_p = .5*pi / fs;
% omega_s = .6*pi / fs;
omega_p = deg2rad(.5*pi) / deg2rad(fs);
omega_s = deg2rad(.6*pi) / deg2rad(fs);

Wp = 2/T * tan(omega_p / 2) / fs;
Ws = 2/T * tan(omega_s / 2) / fs;

%% Butterworth
[n, Wn] = buttord(Wp, Ws, Rp, Rs);
[num, den] = butter(n, Wn);
[Hs, Hz] = analog2Digital(num, den, Wn, 'butterworth');
butterworth.n = n;
butterworth.Wn = Wn;
butterworth.Hs = Hs;
butterworth.Hz = Hz;
butterworth.num = num;
butterworth.den = den;

%% Chebyshev 1
% [n, Wn] = cheb1ord(Wp ,Ws, Rp, Rs);
% [num, den] = cheby1(n, Rp, Wn);
% [Hs, Hz] = analog2Digital(num, den, Wn, 'chebyshev1');
% chebyshev1.n = n;
% chebyshev1.Wn = Wn;
% chebyshev1.Hs = Hs;
% chebyshev1.Hz = Hz;
% chebyshev1.num = num;
% chebyshev1.den = den;

% %% Chebyshev 2
% [n, Wn] = cheb2ord(Wp ,Ws, Rp, Rs);
% [num, den] = cheby2(n, Rp, Wn);
% [Hs, Hz] = analog2Digital(num, den, Wn, 'chebyshev2');
% chebyshev2.n = n;
% chebyshev2.Wn = Wn;
% chebyshev2.Hs = Hs;
% chebyshev2.Hz = Hz;
% chebyshev2.num = num;
% chebyshev2.den = den;

% %% Eliptic
% [n, Wn] = ellipord(Wp, Ws, Rp, Rs);
% [num, den] = ellip(n, Rp, Rs, Wn);
% [Hs, Hz] = analog2Digital(num, den, Wn, 'elliptic');
% elliptic.n = n;
% elliptic.Wn = Wn;
% elliptic.Hs = Hs;
% elliptic.Hz = Hz;
% elliptic.num = num;
% elliptic.den = den;


function [Hs, Hz] = analog2Digital(num, den, Wn, family)
    %
    %======================================================================
    %
    % TODO: 2022-12-12 - ADD Description
    %
    % HOW TO CALL:
    % - TODO: Describe how to call it
    %
    % PARAMS:
    % - TODO: Describe params
    %
    % RETURN:
    % - TODO: Describe return
    %
    % AUTHOR:
    % - TODO: Set author name
    %
    %======================================================================
    %
    
    %% Analog
    Hs = tf(num, den);

    figure;
    pzmap(Hs);
    title(strcat(family, ': Analog'));
    path = strcat('l4-q02-', family, '-graph-01-analog-zp.png');
    saveas(gcf, path);

    % Frequency responses
    [h, w] = freqs(num, den, logspace(-1, 1));

    figure;
    subplot(2, 1, 1);

    hold on;
    % plot(w, abs(h));
    loglog(w, abs(h));
    hold off;

    title(strcat(family, ': Magnitude Response'));
    ylabel('$|H(e^{j \omega})|$', 'Interpreter', 'latex');
    xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
    grid on;

    subplot(2, 1, 2);

    hold on;
    semilogx(w, angle(h)*(180/pi));
    hold off;

    title(strcat(family, ': Phase Response'));
    ylabel('$\theta(\omega))$', 'Interpreter', 'latex');
    xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
    grid on;

    path = strcat('l4-q02-', family, '-graph-02-analog-freq.png');
    saveas(gcf, path);

    %% Digital
    [numd, dend] = bilinear(num, den, Wn);
    Hz = tf(numd, dend, -1);

    figure;
    pzmap(Hz);
    title(strcat(family, ': Digital'));
    path = strcat('l4-q02-', family, '-graph-03-digital-zp.png');
    saveas(gcf, path);

    % Frequency responses
    [h, w] = freqz(numd, dend, 'whole');
    % h = fftshift(h);
    % w = w - pi;

    figure;
    subplot(2, 1, 1);

    hold on;
    plot(w, abs(h));
    hold off;

    title(strcat(family, ': Magnitude Response'));
    ylabel('$|H(e^{j \omega})|$', 'Interpreter', 'latex');
    xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
    grid on;

    subplot(2, 1, 2);

    hold on;
    plot(w, phase(h));
    hold off;

    title(strcat(family, 'Phase Response'));
    ylabel('$\theta(\omega))$', 'Interpreter', 'latex');
    xlabel('$\omega$ (rad)', 'Interpreter', 'latex');
    grid on;

    path = strcat('l4-q02-', family, '-graph-04-digital-freq.png');
    saveas(gcf, path);
    
end