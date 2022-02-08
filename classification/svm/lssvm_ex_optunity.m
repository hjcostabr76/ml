%% **************************************************
%% -- Functional API --
%% **************************************************

% --------------------------------------------------
% Run using Simplex

[gam, sig2] = tunelssvm({ X, Y, type, [], [], 'RBF_kernel' }, 'simplex', 'crossvalidatelssvm', { L_fold, 'misclass' });
[alpha, b] = trainlssvm({ X, Y, type, gam, sig2, 'RBF_kernel' });
plotlssvm({ X, Y, type, gam, sig2, 'RBF_kernel' }, { alpha, b });

% --------------------------------------------------
% 2nd run using Grid Search
% It's possible to use gridsearch in the 2nd run (as replacement for simplex) 

[gam, sig2] = tunelssvm({ X, Y, type, [], [], 'RBF_kernel' }, 'gridsearch', 'crossvalidatelssvm', { L_fold, 'misclass' });

% --------------------------------------------------
% ROC Curve (Receiver Operating Characteristic)
% It gives info about classifiers quality

% Latent variables are needed to make the ROC curve
Y_latent = latentlssvm({ X, Y, type, gam, sig2, 'RBF_kernel' }, { alpha, b }, X);
[area, se, thresholds, oneMinusSpec, Sens] = roc(Y_latent, Y);

%% **************************************************
%% -- Object Oriented API --
%% **************************************************

model = initlssvm(X, Y, type, [], [], 'RBF_kernel');
model = tunelssvm(model, 'simplex', 'crossvalidatelssvm', { L_fold, 'misclass' });
model = trainlssvm(model);

plotlssvm(model);

% --------------------------------------------------
% ROC Curve (Receiver Operating Characteristic)
% It gives info about classifiers quality

% latent variables are needed to make the ROC curve
Y_latent = latentlssvm(model, X);
[area, se, thresholds, oneMinusSpec, Sens] = roc(Y_latent, Y);


%% **************************************************
% ---------------------------------------------------
%% -- One line solution --
% ---------------------------------------------------
% - Automatically tunes the tuning parameters via 10-fold CV or 'leave-one-out' CV (depending on sample size)
% - Automatically plot the solution (when possible)
% - Default kernel: Gaussian RBF;
% ---------------------------------------------------
%% **************************************************

type = 'classification';
Yp = lssvm(X, Y, type);