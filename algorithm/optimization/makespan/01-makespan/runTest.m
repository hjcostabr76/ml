close all; clear

% Set training paramterers
kMax = 5;  % Max neighborhoods
maxEpochs = 20000;

% Run optimizations experiments
history1 = vns(kMax, maxEpochs);
history2 = vns(kMax, maxEpochs);
history3 = vns(kMax, maxEpochs);
history4 = vns(kMax, maxEpochs);
history5 = vns(kMax, maxEpochs);

% Parse experiment results
[epochs1, whatever] = size(history1)
[epochs2, whatever] = size(history2)
[epochs3, whatever] = size(history3)
[epochs4, whatever] = size(history4)
[epochs5, whatever] = size(history5)

max1 = history1(epochs1, 1);
max2 = history2(epochs2, 1);
max3 = history3(epochs3, 1);
max4 = history4(epochs4, 1);
max5 = history5(epochs5, 1);

aux = [max1 max2 max3 max4 max5];
min = min(aux);
max = max(aux);
stdDev = std(aux);

fprintf('\nMin time: %d\n', min);
fprintf('Max time: %d\n', max);
fprintf('Std Deviation: %.2f\n', stdDev);

% Plot history: Epoch X maxTimes
figure, hold on

plt1 = plot(1:epochs1, history1(:, 1)', 'r-', 'LineWidth', 2);
plt2 = plot(1:epochs2, history2(:, 1)', 'g-', 'LineWidth', 2);
plt3 = plot(1:epochs3, history3(:, 1)', 'b-', 'LineWidth', 2);
plt4 = plot(1:epochs4, history4(:, 1)', 'c-', 'LineWidth', 2);
plt5 = plot(1:epochs5, history5(:, 1)', 'm-', 'LineWidth', 2);

title(sprintf('Optimization Executions kMax: %d | maxEpochs: %d', kMax, maxEpochs))
ylabel('Max Execution Time')
xlabel('Epochs')
legend([plt1, plt2, plt3, plt4, plt5], 'Execution 01', 'Execution 02', 'Execution 03', 'Execution 04', 'Execution 05')
hold off
