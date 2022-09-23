close all;

%% Config
beginTime = now;
dateFormat = 'HH:MM';
beginTimeStr = datestr(beginTime, dateFormat);

% Set problem data
aux = xlsread('i5x25.xlsx');

problemData.dueDate = aux(28, 2);
problemData.taskPenalty = aux(2:26, 7)';
problemData.taskTimeTable = aux(2:26, 2:6);

% Set training parameters
obj1 = @objMakespan;
obj2 = @objWeightedSum;

vnsParams.kMax = 4; % Max neighborhoods
vnsParams.maxEpochs = 1000; % Max neighborhood changes
vnsParams.maxRestarts = 10; % Max times a new initial solution can be set during vns
vnsParams.maxHaltedEpochs = 10; % Max tryings to improve a solution locally

nTests = 5;
nSolutions = 20;

%% Test by weighted sum method
paretoList = cell(nTests, nSolutions);

logPrefix = '[pSum]';
for i = 1:nTests
    fprintf('\n%s [test %d] starting at %s\n', logPrefix, i, datestr(now, dateFormat));
    paretoList{i} = pw(i, problemData, obj1, obj2, nSolutions, vnsParams);
end

fprintf('\n >> %s FINISH <<<\nTime Elapsed: %s (%s to %s)\n', logPrefix, datestr(now - beginTime, dateFormat), beginTimeStr, datestr(now, dateFormat));

%% Plot each test frontier
allSolutions = cell(nSolutions * nTests, 1);
i = 0;

for j = 1:nTests

    % Compute all data of this frontier
    pareto = paretoList{j};
    paretoSize = length(pareto);

    delays = zeros(paretoSize, 1);
    makespans = zeros(paretoSize, 1);

    for k = 1:paretoSize
        i = i + 1;
        solution = pareto{k};
        allSolutions{i} = solution;
        makespans(k) = solution.makespan;
        delays(k) = solution.weightedDelay;
    end

    % Plot
    figure; hold on;
    plot(makespans, delays, 'or');
    title(strcat("[Test\_", string(j), '] Pareto Frontier'));
    xlabel('Makespan');
    ylabel('Weighted Delay');
    hold off;
end

%% Plot whole optimization frontier
[finalFrontier, makespans, delays] = getFinalFrontier(allSolutions, i);

figure; hold on;
plot(makespans, delays, 'or');
title('Pareto Final Frontier');
xlabel('Makespan');
ylabel('Weighted Delay');
hold off;

%% Plot each test Pareto results
figure; hold on;
tiledlayout(nTests, 2);
columnsGraphX = linspace(1, nSolutions, nSolutions);

for i = 1: nTests
    
    % Grab optmized values
    pareto = paretoList{i};
    paretoSize = length(pareto);
    
    makespans = zeros(paretoSize, 1);
    maxDelays = zeros(paretoSize, 1);

    for j = 1:paretoSize
        makespans(j) = pareto{j}.makespan;
        maxDelays(j) = pareto{j}.weightedDelay;
    end
    
    % Plot makespan bar graph
    ax = nexttile;
    minV = min(makespans);
    maxV = max(makespans);
    stdDev = round(std(makespans));
    
    stem(ax, columnsGraphX, makespans);
    yline(minV, '--g');
    yline(maxV, '--r');
    title(ax, strcat("[Test\_", string(i), '] Pareto Solutions (makespan)'));
    legend(strcat('Std deviation:\_', string(stdDev)));
    xlabel('Solutions');
    ylabel('Makespan');
    
    % Plot delays bar graph
    ax = nexttile;
    minV = min(maxDelays);
    maxV = max(maxDelays);
    stdDev = round(std(maxDelays));

    stem(ax, columnsGraphX, maxDelays);
    yline(minV, '--g');
    yline(maxV, '--r');
    title(ax, strcat("[Test\_", string(i), '] Pareto Solutions (delay)'));
    legend(strcat('Std deviation:\_', string(stdDev)));
    xlabel('Solutions');
    ylabel('Weighted delay');
end

hold off;