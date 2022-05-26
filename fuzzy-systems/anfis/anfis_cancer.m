clear; close all; clc;

%% Read dataset
ds = readtable('./file/ds_cancer.csv');
% summary(ds);
nRows = size(ds, 1);

features = ds.Properties.VariableNames(3:end);
classCol = ds.Properties.VariableNames(2);

classPositive = 'M'; % Malign (has cancer)
classNegative = 'B'; % Benign (does not have cancer)

dsNorm = getNormalizedTable(ds, features);
X = dsNorm{:, features};
Y = double(convertCharsToStrings(ds{:, classCol}) == classPositive);

%% Split cross validation data
trainRate = .7;
nFolds = 5;
folds = getXValidationFolds(X, Y, trainRate, nFolds);

%% Create initial fis
clusters = [2, 3, 4, 5, 6, 7, 8, 9, 10];
nEpochs = 200;
nFeatures = length(features);

bestFold.fis = -1;
bestFold.number = 1;
bestFold.accuracy = 0;

getYHat = @(fis, xTest) int8(evalfis(fis, xTest) > .5);
getAccuracy = @(yHat, yTest) 100 * (sum(yHat == yTest) / length(yTest));

for i = 1:nFolds

    [fis, nClusters, accuracy] = trainFcm(i, clusters, folds{i}, getYHat, getAccuracy);
    
    if accuracy > bestFold.accuracy
        bestFold.fis = fis;
        bestFold.number = i;
        bestFold.accuracy = accuracy;
    end

    figure(i);
    for j = 1:nFeatures
        [x, mf] = plotmf(fis, 'input', j);
        subplot(nFeatures, 1, j);
        plot(x, mf);
        xlabel(strcat('Membership Functions for input "', features(j), '"'));
    end
    
    sgtitle(strcat('FCM [fold #', string(i), '] Best: (', string(nClusters), ' ', ' clusters) / ', string(accuracy), '% accuracy'));
end

%% Retrain

% Config
cfg = anfisOptions('InitialFIS', bestFold.fis);
cfg.EpochNumber = nEpochs;
% cfg.InputMembershipFunctionType = 'gaussmf';

% Train
[fis, error] = anfis([X Y], cfg); % error = 'Root Mean Squared Error'
yHat = getYHat(fis, X);
accuracy = getAccuracy(yHat, Y);

% Plot final results
figure(nFolds + 1); hold on;

subplot(1, 2, 1);
stem(1:1:nRows, Y, 'b');
xlabel('Real Classification');

subplot(1, 2, 2);
stem(1:1:nRows, yHat, 'r');
xlabel('Approximated Result');

sgtitle(strcat('ANFIS Final Result: ', string(accuracy), '% accuracy'));
legend('Original', 'Approximated');
