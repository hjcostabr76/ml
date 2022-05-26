
function [machineTimes] = fobj(x, taskTimeTable)

    %
    % ===================================================================
    % Objective funciton 01: Minimize makespan
    % -------------------------------------------------------------------
    %
    % - H: Makespan =  max t_k;
    % - t_k: Total time interval from t zero until machine k finish it's last task;
    % - t_[i, k]: Time to machine k finish task i (coms from input data);
    %
    % -------------------------------------------------------------------
    % ===================================================================
    %

    [tasksCount, machinesCount] = size(taskTimeTable);
    machineTimes = zeros(1, machinesCount);

    for k = 1:machinesCount
        for i = 1:tasksCount
            if x(i, k) > 0
                task = x(i, k);
                machineTimes(k) = machineTimes(k) + taskTimeTable(task, k);
            end
        end
    end
end
