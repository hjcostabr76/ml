%
%======================================================================
%
% Simulates Two Carts system using Runge Kutta integration algorythm.
%
% This script is built inspired by the Cord Model script of professor Antonio Aguirre.
% Available in: TODO: ADD Link
%
%======================================================================
%

clear; close all

% Set simulation parameters
h = 0.1;  % integration interval
t0 = 0;         % Initial time
tEnd = 100;       % Final time
t = t0:h:tEnd-1;  % Time vector
interval = length(t);

% Initialize state
% x0 = [.1; .1; .1; .1; .1];  % Initial State
x0 = [0; 0; 0; 0; 0];  % Initial State
x = [x0 zeros(length(x0), interval - 1)];

% Initialize Output
y0 = [0; 0];  % y1 == p1' == 1st Cart speed / y2 == p2' == 2nd Cart speed
y = [y0 zeros(length(y0), interval - 1)];

% Set Input
SIGN_T_STEP = 1;
SIGN_T_PULSE = 2;
SIGN_T_PULSE_LONGER = 3;
SIGN_T_PULSES = 4;
SIGN_T_SINE = 5;
SIGN_T_RANDOM = 6;
SIGN_T_INCREASING_STEPS = 7;

amplitude = 2.03;
signalStartT = 70;

u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_STEP);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_PULSE);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_PULSE_LONGER);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_PULSES);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_SINE);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_RANDOM);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_INCREASING_STEPS);

% Run integration
for k=2:interval
    x(:, k) = getRungeKutta(x(:, k-1), u(k), h, t(k));
    y(:, k) = getOutput(x(:, k-1), u(k), t(k));
end

% Plot results: 1st cart velocity
figure(1)

plot(t, y(1, :), 'r-');
title('1st cart velocity')
xlabel('time')
yyaxis right
ylabel('Velocity')
hold on

plot(t, u, 'b-');
xlabel('time')
yyaxis left
ylabel('External Force')
hold off

% Plot results: 2nd cart velocity
figure(2)

plot(t, y(2, :), 'M-');
title('2nd cart velocity')
xlabel('time')
yyaxis right
ylabel('Velocity')
hold on

plot(t, u, 'b-');
xlabel('time')
yyaxis left
ylabel('External Force')
hold off