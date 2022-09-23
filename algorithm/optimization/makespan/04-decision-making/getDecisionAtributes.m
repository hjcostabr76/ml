function [makespan, delay, advance, netAdvance] = getDecisionAtributes(taskDistribution, problemData)
    %
    %======================================================================
    %
    % Calculates decision attributes for 01 alternative (solution) of the problem.
    % NOTE: The order that attibutes are returned matters! Keep it this way.
    %
    % PARAMS:
    % - taskDistribution: Array of the tasks allocation among machines of the current solution;
    % - problemData: Struct with problem configuration parameters;
    %
    % RETURN:
    % - makespan: Number;
    % - delay: Number;
    % - advance: Number;
    % - netAdvance: Number (advance - delay);
    %
    %======================================================================
    %

    [tasksCount, machinesCount] = size(problemData.taskTimeTable);

    delays = zeros(1, machinesCount);
    advances = zeros(1, machinesCount);
    netAdvances = zeros(1, machinesCount);
    machineTimes = zeros(1, machinesCount);

    for k = 1:machinesCount
        for i = 1:tasksCount

            % Check if this task is alocated to this machine at this moment
            task = taskDistribution(i, k);
            if ~task
                continue;
            end
            
            machineTimes(k) = machineTimes(k) + problemData.taskTimeTable(task, k);
            delay = max(0, machineTimes(k) - problemData.dueDate);
            advance = min(0, machineTimes(k) - problemData.dueDate);

            delays(task) = delay * problemData.taskPenalty(task);
            advances(task) = advance * problemData.taskPenalty(task);
            netAdvances(task) = (advance - delay) * problemData.taskPenalty(task);

        end
    end

    makespan = max(machineTimes);
    delay = 0;
    advance = 0;
    netAdvance = 0;

    for j = 1:tasksCount
        delay = delay + delays(j);
        advance = advance + advances(j);
        netAdvance = netAdvance + netAdvances(j);
    end
    
    fprintf('makespan: %d; delay: %.2f; advance: %.2f; netAdvance: %.2f', makespan, delay, advance, netAdvance);
end
