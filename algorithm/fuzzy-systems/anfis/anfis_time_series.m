close all;

%% Set training data
nEpochs = 100;
trainRate = .8;

delay1 = 18;
delay2 = 12;
delay3 = 6;
delay4 = 0;

advance = 6;
delayxMax = max([delay1 delay2 delay3 delay4]);

x1 = getShiftedSeries(tSeries, delay1);
x2 = getShiftedSeries(tSeries, delay2);
x3 = getShiftedSeries(tSeries, delay3);
x4 = getShiftedSeries(tSeries, delay4);
y = getShiftedSeries(tSeries, -advance);

X = [x1 x2 x3 x4];
X = X(delayxMax: end-advance, :);
y = y(delayxMax: end-advance);

%% Split training X test
nTotal = length(y);
nTrain = round(trainRate * nTotal);
nTest = nTotal - nTrain;

trainIdx = randperm(nTotal, nTrain);

XTrain = X(trainIdx, :);
yTrain = y(trainIdx);
XTest = X(setdiff(1:end, trainIdx), :);
yTest = y(setdiff(1:end, trainIdx), :);

%% Set model configuration
cfg = genfisOptions('GridPartition');
cfg.InputMembershipFunctionType = 'gaussmf';
model = genfis(XTrain, yTrain, cfg);

cfg = anfisOptions('InitialFIS', model);
cfg = anfisOptions();
cfg.EpochNumber = nEpochs;

%% Train
[model, error] = anfis([XTrain yTrain], cfg); % error = 'Root Mean Squared Error'
yHat = evalfis(model, XTest);

%% Plot results
figure; hold on;
times = 1:1:length(yTest);
plot(times, yTest, '*r');
plot(times, yHat, ':ok');

title(strcat('Time Series Prediction [', string(nEpochs), ' epochs] | error = ', string(min(error))))
legend('Original', 'Approximated')
xlabel('time');
ylabel('Value');
grid on;
hold off;

function shiftedSeries = getShiftedSeries(series, delay)
    shiftedSeries = zeros(length(series), 1);
    if delay >= 0 % Delay
        shiftedSeries(delay+1:end, :) = series(1 :end-delay);
    else % Advance
        shiftedSeries(1: end+delay, :) = series(-delay+1: end);
    end
end