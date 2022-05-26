
%
%======================================================================
%
% Cube sprint linear approximated model.
%
%======================================================================
%

clear
close all

% Set cubic function
k = 1.5;
alpha = 2;
cubicSpring = @(x) k*x + k*alpha*x.^3;
X = linspace(-5, 5, 40);
y = cubicSpring(X);
yApprox = arrayfun(@(x) getCubeSpringApprox(x), X);

% Plot cubic graph
figure(1);
plot(X, y, 'b-');
title(strcat('Cube Sprint Curve: k = ', string(k), ' alpha = ', string(alpha)));
grid on;
hold on;

% Plot linear approximation
plot(X, abs(y - yApprox), 'r-');
plot(X, yApprox, 'g-');

legend('Cube spring curve', 'Linear approximation', 'error');
hold off;
