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
h = 0.5;            % integration interval
t0 = 0;             % Initial time
tEnd = 80;         % Final time
t = t0:h:tEnd-1;    % Time vector
interval = length(t);

beta = 108.33;      % Linear approximation slope (linear eq 'a')
lambda = 2*beta;    % Linear approximation 'b'
maxDisplacement = 5

% Initialize state
q0 = [0; 0; 0; 0; lambda];  % Initial State
q = [q0 zeros(length(q0), interval - 1)];

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

amplitude = .5;
signalStartT = 10;

u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_STEP);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_PULSE);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_PULSE_LONGER);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_PULSES);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_SINE);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_RANDOM);
% u = getInputSignal(amplitude, signalStartT, interval, SIGN_T_INCREASING_STEPS);

% Run integration
for k=2:interval
    
    % Update state
    q(:, k) = getRungeKutta(q(:, k-1), u(k), h, t(k));

    % Update output
    p1 = q(1, k) % 1st cart position
    p2 = q(3, k) % 2nd cart position

    isOutOfBounds = abs(p2) > maxDisplacement || abs(p1) > maxDisplacement
    if ~isOutOfBounds
        v1 = q(2, k) % 1st cart velocity
        v2 = q(4, k) % 2nd cart velocity
    else

        v1 = 0
        v2 = 0

        if q(1, k) > maxDisplacement
            q(1, k) = maxDisplacement
        else
            q(1, k) = -maxDisplacement
        end

        if q(1, k) > maxDisplacement
            q(3, k) = maxDisplacement
        else
            q(3, k) = -maxDisplacement
        end
    end
    
    y(:, k) = [v1; v2];
end

% Plot results: 1st cart velocity
figure(1)

plot(t, u, 'b-');
title('1st cart velocity')
xlabel('time')
hold on

plot(t, y(1, :), 'g-');
plot(t, q(1, :), 'r-');

legend('Fe: External Force [N}', 'v1: 1st cart velocity [m/s]', 'p1: 1st cart position [m]')
hold off

% Plot results: 2nd cart velocity
figure(2)

plot(t, u, 'b-');
title('2nd cart velocity')
xlabel('time')
hold on

plot(t, y(2, :), 'g-');
plot(t, q(3, :), 'r-');

legend('Fe: External Force [N}', 'v2: 2nd cart velocity [m/s]', 'p2: 2nd cart position [m]')
hold off