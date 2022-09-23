function isValid = isRestrictionsValid(distribution)

    isValid = true;
    [tasksCount, machinesCount] = size(distribution);
    allTasks = linspace(1, tasksCount, tasksCount);
    
    tasksMap = [allTasks', zeros(tasksCount, 1)];
    for i = 1:tasksCount
        for k = 1:machinesCount
            task = distribution(i, k);
            if ~task
                continue;
            elseif tasksMap(task, 2)
                isValid = false;
                return;
            end

            tasksMap(task, 2) = 1;
        end
    end

    for task = 1:tasksCount
        if ~tasksMap(task, 2)
            isValid = false;
            return;
        end
    end
end