%% Load dataset
ds = readtable('./file/ds_glass.csv');

features = ds.Properties.VariableNames(1:end-1);
X = ds{:, features};
Y = ds{:, end};

%% Build Model

% Initilize
type = 'classification'; % Alternative: 'regression'
kernelType = 'RBF_kernel';
model = initlssvm(X, Y, type, [], [], kernelType);

accuracies = zeros(1, 10);
gammas = zeros(1, 10);
sigma2s = zeros(1, 10);

for i = 1:10
    
    % Tweak and train
    cvFolds = 10;
    costArgs = { cvFolds, 'misclass' };
    optFunction = 'simplex'; % Optimization function
    costFunction = 'crossvalidatelssvm';

    model = tunelssvm(model, optFunction, costFunction, costArgs);

    %% Evaluate result
    gamma(i) = model.gam(1);
    sigma2s(i) = model.kernel_pars(1);
    yHat = simlssvm(model, X);
    accuracies(i) = sum(Y == yHat) / length(Y);

end

%% Evaluate result
avgAccuracy = sum(accuracies)  / length(accuracies);
stdDev = std(accuracies);
plotlssvm(model);

% if size(costargs,2)==1, error('Specify the number of folds for CV'); end