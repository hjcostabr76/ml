function objParams = objMakespan(objParams, problemData)

    %
    % ===================================================================
    % Objective funciton 01: Minimize makespan
    % -------------------------------------------------------------------
    %
    % - objParams: Objective function parameters.
    % - problemData: Constant data read from input data file;
    %
    % -------------------------------------------------------------------
    % ===================================================================
    %

    [tasksCount, machinesCount] = size(problemData.taskTimeTable);
    machineTimes = zeros(1, machinesCount);

    for k = 1:machinesCount
        for i = 1:tasksCount
            task = objParams.taskDistribution(i, k);
            if task
                machineTimes(k) = machineTimes(k) + problemData.taskTimeTable(task, k);
            end
        end
    end

    objParams.machineTimes = machineTimes;
    objParams.makespan = max(machineTimes);
end
