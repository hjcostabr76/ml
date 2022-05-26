close all;

%% Set parameters
nEpochs = 10;

xTrain = (0:.1:2*pi)';
xTest = (0:.05:2*pi)';
yTrain = sin(xTrain);
yTest = sin(xTest);

% Set model configuration
cfg = genfisOptions('GridPartition');
cfg.InputMembershipFunctionType = 'gaussmf';
model = genfis(xTrain, yTrain, cfg);

cfg = anfisOptions('InitialFIS', model);
cfg.EpochNumber = nEpochs;

%% Train
[model, error] = anfis([xTrain yTrain], cfg); % error = 'Root Mean Squared Error'
yHat = evalfis(model, xTest);

%% Plot results
figure; hold on;
plot(xTest, yTest, '.b');
plot(xTest, yHat, '*r');

title(strcat('Sine function approximation [', string(nEpochs), ' epochs] | error = ', string(min(error))))
legend('Original', 'Approximated')
xlabel('x');
ylabel('sin(x)');
xlim([0 2*pi]);
ylim([-1.1 1.1]);
hold off;