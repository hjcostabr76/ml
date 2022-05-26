clear all; clc; close all;

amplitude = 1;
tBegin = 0;
tEnd = 250;

% %% Generate input
% u = getInputSignal(amplitude, tBegin, tEnd, 6); % Random

% Impulse
u = getInputSignal(amplitude, tBegin, tEnd, 2);
run(u, 'Resposta ao Impulso', tEnd, amplitude);

% Degrau
u = getInputSignal(amplitude, tBegin, tEnd, 1);
run(u, 'Resposta ao Degrau', tEnd, amplitude);

function run(u, name, tEnd, amplitude)
    %
    %======================================================================
    %
    % TODO: 2022-02-19 - ADD Description
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
   
    %% Define system
    t = 1:1:tEnd;
    H = tf(1, [1 .2 .8]);
    y = lsim(H, u, t);

    % Plot ideal system
    figure(); hold on;
    plot(t, y, '-o'); xlabel('t(s)'); ylabel('y(t)');
    title(name)
    % hold off;

    %% Get approximation for pure ideal system
    sampleSize = 100;
    tForApprox = t(1:sampleSize);

    U = getU(u(1:sampleSize));
    h = inv(U) * y(1:sampleSize);
    yApprox = U*h;

    % % Plot approximation
    % % figure(1); hold on;
    % plot(tForApprox, yApprox, 'X', 'LineWidth', 2); xlabel('t(s)'); ylabel('y(t)');
    % title(title);
    % hold off;

    %% Add noise to system output
    noiseAmplitude = 0.05 * amplitude;
    noise = noiseAmplitude * randn(length(y), 1);
    yNoise = y + noise;

    % Plot system with output noise
    % figure(2); hold on;
    % plot(t, yNoise, '-o'); xlabel('t(s)'); ylabel('y(t)');
    % title(title);
    % hold off;

    %% Get approximation for system with output noise
    h = inv(U) * yNoise(1:sampleSize);
    yApprox = U*h;

    % Plot approximation
    % figure(2); hold on;
    % plot(tForApprox, yApprox, 'X', 'LineWidth', 2); xlabel('t(s)'); ylabel('y(t)');
    % hold off; 
    
end