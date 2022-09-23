function [newPareto, nSolutions] = getNonDominated(lastIdx, currentPareto, newSolution)
    %
    %======================================================================
    %
    % Returns a new pareto set filtering the current one to take dominated solutions out.
    % Test the set against a new solution to take out any now dominated points;
    %
    % PARAMS:
    % - lastIdx: Last [int] element of the set to be compared against the new solution;
    % - currentPareto: [cell array] The set to be filtered;
    % - newSolution: [struct] The new solution that can possibly dominate some of the previous ones;
    %
    % RETURN:
    % - newPareto: [cell array] New set of non dominated solutions (same size of the original array);
    % - nSolutions: [int] New number of non dominated solutions (might be minor than the size of the set array);
    %
    %======================================================================
    %

    newPareto = cell(lastIdx, 1);
    nSolutions = 0;

    for i = 1:lastIdx
        old = currentPareto{i};
        isDominated = newSolution.makespan < old.makespan && newSolution.weightedDelay < old.weightedDelay;
        if ~isDominated
            nSolutions = nSolutions + 1;
            newPareto{nSolutions} = old;
        end
    end
end
