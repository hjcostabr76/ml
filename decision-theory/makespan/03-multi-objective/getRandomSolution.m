function taskDistribution = getRandomSolution(machinesCount, tasksCount)

    taskDistribution = zeros(tasksCount, machinesCount);
    tasks = randperm(tasksCount);

    for i = 1:tasksCount
        k = randi(machinesCount, 1);
        taskDistribution(i, k) = tasks(i);
    end
end
