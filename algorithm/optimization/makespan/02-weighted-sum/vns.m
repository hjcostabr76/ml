% function [maxTime, taskDistribution, taskTimeTable] = VNS()
function [history, somaPonderadaAtrasos, taskDistribution] = vns(kMax, maxEpochs)

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
    taskPenalty = aux(2:26, 7);
    taskPenalty = taskPenalty';
    dueDate = aux(28, 2);

    % Get 1st random solution
    [tasksCount, machinesCount] = size(taskTimeTable);
    [taskDistribution] = getInitialSolution(machinesCount, tasksCount);
    [somaPonderadaAtrasos] = fobj(taskDistribution, taskTimeTable, taskPenalty, dueDate);
    bestSomaPonderadaAtrasos = somaPonderadaAtrasos;
    
    history = zeros(maxEpochs, 2);
    history(1, :) = [bestSomaPonderadaAtrasos, somaPonderadaAtrasos];

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
            [somaPonderadaAtrasos] = fobj(taskDistribution, taskTimeTable, taskPenalty, dueDate);
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
            [newSomaPonderadaAtrasos] = fobj(newDistribution, taskTimeTable, taskPenalty, dueDate);
            
            % Test new variation
            [somaPonderadaAtrasos, taskDistribution, k, haveChanged] = neighborhoodChange(somaPonderadaAtrasos, taskDistribution, newSomaPonderadaAtrasos, newDistribution, k);
            
             if haveChanged
                stationaryEpochs = 0;
            end
        end
        
        if somaPonderadaAtrasos < bestSomaPonderadaAtrasos
            bestSomaPonderadaAtrasos = somaPonderadaAtrasos
        end
        history(epoch, :) = [bestSomaPonderadaAtrasos, somaPonderadaAtrasos];
    end
    
    fprintf('End of Execution after %d epochs with %d resets. Best time: %.2f\n', epoch, resetsCount, bestSomaPonderadaAtrasos);
    
end