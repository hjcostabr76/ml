clc; clear all; close all;
nFig = 0;

%
%======================================================================
%% Import Data
%======================================================================
%

ds  = load('file/tmsd_tarefa5.txt');
tDs  = ds(:, 1);
uDs  = ds(:, 2);
yDs = ds(:, 3);

%
%======================================================================
%% Split data for identification X Validation
%======================================================================
%

kId = 1000;

tTest = tDs(1:kId);
uTest = uDs(1:kId);
yTest = yDs(1:kId);

tId = tDs(kId+1:end);
uId = uDs(kId+1:end);
yId = yDs(kId+1:end);

% Plot sample input
nFig = nFig + 1; figure(nFig);
subplot(411);
plot(tDs, uDs);
title('Input');

% Plot full sample output
subplot(412);
plot(tDs, yDs, 'k');
grid on;
title('output');

% Plot validation output
subplot(413);
aux = zeros(1, length(tDs));
aux(1:kId) = yTest;

plot(tDs, aux, 'r');
grid on;
title('Validaton Output');

% Plot identification output
subplot(414);
aux = zeros(1, length(tDs));
aux(kId+1:end) = yId;

plot(tDs, aux, 'r');
grid on;
title('Identification Output');

saveas(gcf, getFilePath('02-01-sample-data'));

%
%======================================================================
%
%% Decimation
%
% - We analyse autocorrelation graphs;
% - The cryteria is that we find our lowest auto correlation between 5 ~ 25 delay time units;
% - So we choose the decimation factor that "shrinks" the curve so the minimum correlation fits the restriction;
%
% Graph analysis shows that output minimum correlation occurs by the time 32. It is clear that it would not
% harm the input reading so use this reference value.
% 
%======================================================================
%

%% Parse auto correlations
[tuu, ruu, luu, Buu] = myccf([uId uId], 300, 0, 0); % For input
[tyy, ryy, lyy, Byy] = myccf([yId yId], 300, 0, 0); % For output

nFig = nFig + 1; figure(nFig);
subplot(211);

hold on;
plot(tuu, ruu, 'k');
plot(tuu, luu*ones(length(tuu)), ':k', 'markersize', 0.5);
plot(tuu, -luu*ones(length(tuu)), ':k', 'markersize', 0.5);

title('Input Auto Correlation');
hold off;

subplot(212);
hold on;
plot(tyy, ryy, 'k');
plot(tyy, lyy*ones(length(tyy)), ':k', 'markersize', 0.5);
plot(tyy, -lyy*ones(length(tyy)), ':k', 'markersize', 0.5);
xline(32, ':m')

title('Output Auto Correlation');
hold off;

saveas(gcf, getFilePath('02-02-auto-correlation'));

%% Set decimated sample
decFactor = round(32 / 5);

tIdDec = tId(1:decFactor:end);
uIdDec = uId(1:decFactor:end);
yIdDec = yId(1:decFactor:end);

tTestDec = tTest(1:decFactor:end);
uTestDec = uTest(1:decFactor:end);
yTestDec = yTest(1:decFactor:end);

%% Plot decimation for identification
nFig = nFig + 1; figure(nFig);
subplot(411);
plot(tId, uId);
title('Regular Input (identification)');

subplot(412);
plot(tIdDec, uIdDec);
title('Decimated Input (identification)');

subplot(413);
plot(tId, yId, 'r');
grid on;
title('Regular Output (identification)');

subplot(414);
plot(tIdDec, yIdDec, 'r');
grid on;
title('Decimated Output (identification)');

saveas(gcf, getFilePath('02-03-decimated-id'));

%% Plot decimation for validation
nFig = nFig + 1; figure(nFig);
subplot(411);
plot(tTest, uTest);
title('Regular Input (validation)');

subplot(412);
plot(tTestDec, uTestDec);
title('Decimated Input (validation)');

subplot(413);
plot(tTest, yTest, 'r');
grid on;
title('Regular Output (validation)');

subplot(414);
plot(tTestDec, yTestDec, 'r');
grid on;
title('Decimated Output (validation)');

saveas(gcf, getFilePath('02-04-decimated-validation'));

%% Check if input and output remain sufficiently coorelated after decimation
[tuy, ruy, luy, Buy] = myccf([yIdDec uIdDec], 100, 1, 0);

nFig = nFig + 1; figure(nFig);
hold on;
plot(tuy, ruy);
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5);
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5); 

title('Crossed Correlation Input X Output (after decimation)');
hold off;

saveas(gcf, getFilePath('02-05-crossed-correlation'));

%
%======================================================================
%
%% Structure selection
%
% Using two order selection models for comparison. The goal is to decide the
% best order for the ARX model.
%
%======================================================================
%

%% Prepare data (remove mean and pure delay)
% pureDelay = 1;
% tIdDec = tIdDec(1:end-pureDelay-1);
% uIdDec = uIdDec(pureDelay:end);
% yIdDec = yIdDec(1:end-pureDelay-1);

uIdDec = uIdDec - mean(uIdDec);
yIdDec = yIdDec - mean(yIdDec);

%% Select model order
N = 15;
Y = yIdDec(N:end);
aic = zeros([1, N-1]);
bic = zeros([1, N-1]);

psi = [];
for k = 1:(N-1)
    psi = [psi yIdDec(N-k:end-k)];
    theta = pinv(psi)*Y;
    xi = Y - psi*theta;
    aic(k) = getArkaike(xi, k);
    bic(k) = getBayes(xi, k);
end

nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(aic);
title('Arkaike Cryteria');
xlabel('Model Order');
hold off;

subplot(212);
hold on;
plot(bic);
title('Bayes Cryteria');
xlabel('Model Order');
hold off;

saveas(gcf, getFilePath('02-06-order-selection'));

%
%======================================================================
%% Validation
%======================================================================
%

%% Estimate parameters
nParams = 10;
ini = 6;
lambda=0.998; % Fator de esquecimento
params = getRecursiveEstimation(uIdDec, yIdDec, nParams, ini, lambda);

%% Estimate output with "one step ahead"
yHatStep = zeros([1, length(yTestDec)]);
for k = ini:length(yTestDec)
    yHatStep(k) = dot([yTestDec(k-1), yTestDec(k-2), yTestDec(k-3), yTestDec(k-4), yTestDec(k-5), uTestDec(k-1), uTestDec(k-2), uTestDec(k-3), uTestDec(k-4), uTestDec(k-5)], params);
end

nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(yHatStep');
plot(yTestDec, ':r', 'markersize', 0.5);
title('One step ahead estimation');
legend('Estimation', 'Validation data')
hold off;

subplot(212);
plot(yTestDec - yHatStep', 'r');
title('Error');
grid on;

saveas(gcf, getFilePath('02-07-estimation-one-step-ahead'));

%% Estimate output with "free simulation"
yHatFree = zeros([1, length(yTestDec)]);
yHatFree(1:5) = yTestDec(1:5)';

for k = ini:length(yTestDec)
    yHatFree(k) = dot([yHatFree(k-1), yHatFree(k-2), yHatFree(k-3), yHatFree(k-4), yHatFree(k-5), uTestDec(k-1), uTestDec(k-2), uTestDec(k-3), uTestDec(k-4), uTestDec(k-5)], params);
end

nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(yHatFree');
plot(yTestDec, ':r', 'markersize', 0.5);
title('Free simulation estimation');
legend('Estimation', 'Validation data')
hold off;

subplot(212);
plot(yTestDec - yHatFree', 'r');
title('Error');
grid on;

saveas(gcf, getFilePath('02-08-estimation-free-simulation'));


%% Get RMSE
[rmse1, rmse2] = getRMSE(yTestDec, yHatStep, yHatFree);

%
%======================================================================
%% Verify Residues
%======================================================================
%

%% Analysis: Free simulation correlations
resFree = yTestDec - yHatFree';

% Auto Correlation
[tuy, ruy, luy, Buy] = myccf([resFree resFree], 40, 0, 0);

nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(tuy, ruy);
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5);
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5); 

title('Auto Correlation (Free Simulation Output)');
hold off;

% Crossed Correlation
[tuy, ruy, luy, Buy] = myccf([uTestDec resFree], 40, 1, 0);

subplot(212);
hold on;
plot(tuy, ruy);
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
title('Crossed Correlation (Free simulation input \times output)');
hold off

saveas(gcf, getFilePath('02-09-correlation-free-estimation'));

%% Analysis: One step ahead correlations
resStep = yTestDec - yHatStep';

% Auto Correlation
[tuy, ruy, luy, Buy] = myccf([resStep resStep], 40, 0, 0);

nFig = nFig + 1; figure(nFig);
subplot(211);
hold on;
plot(tuy, ruy);
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5);
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5); 

title('Auto Correlation (One step ahead Output)');
hold off;

% Crossed Correlation
[tuy, ruy, luy, Buy] = myccf([uTestDec resStep], 40, 1, 0);

subplot(212);
hold on;
plot(tuy, ruy);
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
title('Crossed Correlation (One step ahead input \times output)');
hold off

saveas(gcf, getFilePath('02-10-correlation-one-step-ahead'));