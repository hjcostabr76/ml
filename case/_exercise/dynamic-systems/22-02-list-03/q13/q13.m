close all; clear; clc;

h = [0 0 0 3 2.5 1 0 -1 0 .5 0 0 0];
x = [0 0 0 1 2 3 2 2 1 0 0 0 0];
y = cconv(x, h);
yHat = frequencyFiltering(x, h);
N = length(y);

% Calculate mean squared error
sumSquartedError = 0;
for i = 1:N
    sumSquartedError = sumSquartedError + sqrt((yHat(i) - y(i))^2);
end

meanSquaredError = (1/N)*sumSquartedError;

%% Print graphs
figure;

subplot(2, 1, 1);
stem(1:N, [x zeros(1, N - length(x))]);
title('x');
grid on;

subplot(2, 1, 2);
stem(1:N, [h zeros(1, N - length(h))]);
title('h');
grid on;

% Custom implementation test
figure;

subplot(2, 1, 1);
stem(1:N, yHat);
title('y (custom)');
grid on;
ylim([-5 20]);

% MATLAB native function test (to compare)
subplot(2, 1, 2);
stem(1:N, y);
title('y (matlab)');
ylim([-5 20]);
grid on;
