function objParams = vns(id, objFunction, initialSolution, problemData, vnsParams)

    %% Declare objective function parameters
    objParams.id = id;
    objParams.target = Inf;     % Value being minimized - equals 'makespan' or 'weightedDelay' (depending on objFunction)
    objParams.makespan = Inf;   % Current max machine operation time
    objParams.machineTimes = Inf;
    objParams.weightedDelay = Inf;
    objParams.taskDistribution = initialSolution;

    %% Optimize
    [tasksCount, machinesCount] = size(problemData.taskTimeTable);
    objParams = feval(objFunction, objParams);

    epoch = 0;
    haltedEpochs = 0;
    restartsCount = 0;

    while epoch < vnsParams.maxEpochs
        haveImproved = false;
        epoch = epoch + 1;
        k = 1;

        % Check if we are making any progress
        if haltedEpochs >= vnsParams.maxHaltedEpochs
            if restartsCount >= vnsParams.maxRestarts break; end
            restartsCount = restartsCount + 1;
            objParams.taskDistribution = getRandomSolution(machinesCount, tasksCount);
            objParams = feval(objFunction, objParams);
        end

        while k <= vnsParams.kMax
            
            % Shake
            shakenParams = objParams;
            shakenParams.taskDistribution = shake(objParams.taskDistribution);
            shakenParams = feval(objFunction, shakenParams);

            % Evaluate neighborhood
            [objParams, k, haveImprovedNow] = neighborhoodChange(objParams, shakenParams, k);
            haveImproved = haveImproved || haveImprovedNow;
        end

        % Compute progress
        if haveImproved
            haltedEpochs = 0;
        else
            haltedEpochs = haltedEpochs + 1;
        end
    end

    %% Log result
    % fprintf(...
    %     '\n%s [vns] >>End<< After %d epochs with %d restarts. Target: %.2f Makespan: %d; Weight: %d\n',...
    %     id, epoch, restartsCount, objParams.target, objParams.makespan, objParams.weightedDelay...
    % );
    % fprintf('---------------------------------- > < ----------------------------------\n')
end
