function objParams = objWeightedSum(objParams, problemData)

    %
    % ===================================================================
    % Objective function 02: Minimização da soma ponderada dos atrasos
    % -------------------------------------------------------------------
    %
    % - objParams: Objective function parameters.
    % - problemData: Constant data read from input data file;
    %
    % -------------------------------------------------------------------
    % ===================================================================
    %

    [tasksCount, machinesCount] = size(problemData.taskTimeTable);
    delayPenalties = zeros(1, tasksCount);
    machineTimes = zeros(1, machinesCount);

    for k = 1:machinesCount
        for i = 1:tasksCount

            % Check if this task is alocated to this machine at this moment
            task = objParams.taskDistribution(i, k);
            if ~task
                continue;
            end
            
            machineTimes(k) = machineTimes(k) + problemData.taskTimeTable(task, k);
            delay = max(0, machineTimes(k) - problemData.dueDate);
            delayPenalties(task) = delay * problemData.taskPenalty(task);
        end
    end

    objParams.weightedDelay = 0;
    for j = 1:tasksCount
        objParams.weightedDelay = objParams.weightedDelay + delayPenalties(j);
    end
end
