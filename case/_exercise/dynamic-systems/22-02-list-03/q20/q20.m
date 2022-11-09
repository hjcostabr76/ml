close all; clear; clc;

% Letter B
A = .9;
b = [1 -1];
a = [1 -A];
plotDftCurves(a, b);

% Letter C
A = .99;
b = [1 -1];
a = [1 -A];
plotDftCurves(a, b);

function result = plotDftCurves(a, b)
    %
    %======================================================================
    %
    % TODO: 2022-11-09 - ADD Description
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
    freqz(b, a);
    grid on;
end