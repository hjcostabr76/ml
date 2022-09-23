function [history, bestTime, taskDistribution] = vns(kMax, maxEpochs)

    %
    % ===================================================================
    % -------------------------------------------------------------------
    % TODO: ADD Description
    %
    % -------------------------------------------------------------------
    % ===================================================================
    %

    % Initialize
    aux = xlsread('i5x25.xlsx');
    taskTimeTable = aux(2:26, 2:6);

    % Get 1st random solution
    [tasksCount, machinesCount] = size(taskTimeTable);
    [taskDistribution] = getInitialSolution(machinesCount, tasksCount);
    [machineTimes] = fobj(taskDistribution, taskTimeTable);
    maxTime = max(machineTimes);
    bestTime = maxTime;

    history = zeros(maxEpochs, machinesCount + 2);
    history(1, :) = [bestTime, maxTime, zeros(1, machinesCount)];
    
    % Optimize
    epoch = 0;
    resetsCount = 0;
    stationaryEpochs = 0;

    maxStationaryEpochs = round(.15 * maxEpochs);
    maxResets = ceil(.007 * maxEpochs);

    while epoch < maxEpochs
        epoch = epoch + 1;
        stationaryEpochs = stationaryEpochs + 1;

        if stationaryEpochs > maxStationaryEpochs
            if resetsCount > maxResets
                history = history(1:epoch-1, :);
                break
            end

            resetsCount = resetsCount + 1;
            [taskDistribution] = getInitialSolution(machinesCount, tasksCount);
            [machineTimes] = fobj(taskDistribution, taskTimeTable);
            maxTime = max(machineTimes);
        end

        k = 1;
        i = 0;
        while k <= kMax
            i = i + 1;
            if i > 50*kMax
                throw (MException('myComponent:InputError', '[epoch: %d | k: %d] K is not moving forward...', epoch, k))
            end

            % Shake: Get solution variation
            newDistribution = shake(taskDistribution);
            [newMachineTimes] = fobj(newDistribution, taskTimeTable);
            newMaxTime = max(newMachineTimes);
            
            % Test new variation
            [maxTime, taskDistribution, machineTimes, k, haveChanged] = neighborhoodChange(maxTime, taskDistribution, machineTimes, newMaxTime, newDistribution, newMachineTimes, k);

            if haveChanged
                stationaryEpochs = 0;
            end
        end
        
        if maxTime < bestTime
            bestTime = maxTime
        end
        history(epoch, :) = [bestTime maxTime machineTimes];
    end

    fprintf('End of Execution after %d epochs with %d resets. Best time: %.2f\n', epoch, resetsCount, bestTime);

end