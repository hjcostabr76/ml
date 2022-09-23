function pareto = pw(executionID, problemData, objFunc1, objFunc2, maxSolutions, vnsParams)

    [tasksCount, machinesCount] = size(problemData.taskTimeTable);
    
    solutions = cell(maxSolutions, 1);
    initialSolution = getRandomSolution(machinesCount, tasksCount);
    bestSolution.target = Inf;
    
    epoch = 0;
    nSolutions = 0;
    haltedEpochs = 0;
    restartsCount = 0;
    maxHaltedEpochs = 100;
    maxRestarts = 10;

    while nSolutions < maxSolutions
        epoch = epoch + 1;

        % Set dynanmic params
        aux = rand(2, 1); % 02 objectives
        weights = aux / sum(aux);
        objFunction = @(objParams) objFunctionPw(objFunc1, objFunc2, objParams, problemData, weights);

        % Run optimization
        id = strcat(string(executionID), ".", string(epoch));
        newParams = vns(id, objFunction, initialSolution, problemData, vnsParams);
        initialSolution = newParams.taskDistribution;

        % Evalute result
        haveImproved = willAddNewSol(nSolutions, solutions, newParams);
        if haveImproved

            [solutions, nSolutions] = getNonDominated(nSolutions, solutions, newParams);
            nSolutions = nSolutions + 1;
            solutions{nSolutions} = newParams;

            fprintf(...
                '\n[pw %d] [new solution: %.2f X %.2f] >> Now we have %d (epochs: %d; restarts: %d)...',...
                executionID, newParams.makespan, newParams.weightedDelay, nSolutions, epoch, restartsCount...
            );

            haltedEpochs = 0;
            if (newParams.target < bestSolution.target) bestSolution = newParams; end
            continue;
        end

        % Compute halted epochs
        canTryAgain = haltedEpochs < maxHaltedEpochs;
        if canTryAgain
            haltedEpochs = haltedEpochs + 1;
            continue;
        end
            
        % Make a restart (if we can)
        canRestart = restartsCount < maxRestarts;
        if canRestart
            haltedEpochs = 0;
            restartsCount = restartsCount + 1;
            initialSolution = bestSolution.taskDistribution;
            continue
        end

        % End optimization as we are not going any further
        for j = nSolutions:maxSolutions
            solutions{j} = solutions{nSolutions};
        end
        
        warnInterruption(executionID, nSolutions, epoch, restartsCount)
        break
    end

    % Build actual return with the size of how many solutions were found
    pareto = cell(nSolutions, 1);
    for i = 1:nSolutions
        pareto{i} = solutions{i};
    end
end

function objParams = objFunctionPw(objfunc1, objfunc2, objParams, problemData, weights)
    objParams = feval(objfunc1, objParams, problemData);
    objParams = feval(objfunc2, objParams, problemData);
    objParams.target = dot(weights(:), [objParams.makespan, objParams.weightedDelay]);
end

function will = willAddNewSol(lastIdx, currentPareto, newSolution)
    will = true;
    for i = 1:lastIdx
        isDominated = newSolution.makespan > currentPareto{i}.makespan && newSolution.weightedDelay > currentPareto{i}.weightedDelay;
        if isDominated
            will = false;
            break
        end
    end
end

function warnInterruption(executionID, nSolutions, epoch, restartsCount)
    fprintf('\n\n---------------------------------- > < ----------------------------------')
    fprintf('\n---------------------------------- > < ----------------------------------')
    fprintf('\n[pw %d] >> Warning << Finishing because we are making no more progress\n', executionID);
    fprintf(...
        '[pw %d] >> Warning << %d non dominated solutions found after %d epochs with %d restarts...',...
        executionID, nSolutions, epoch, restartsCount...
    );
    fprintf('\n---------------------------------- > < ----------------------------------')
    fprintf('\n---------------------------------- > < ----------------------------------\n\n')
end