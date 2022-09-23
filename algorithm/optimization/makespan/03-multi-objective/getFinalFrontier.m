function [finalFrontier, makespans, delays] = getFinalFrontier(allSolutions, nSolutions)

    % Build final frontier
    nonDominated = allSolutions;
    nFinal = nSolutions;

    for i = 1:nSolutions
        [nonDominated, nFinal] = getNonDominated(nFinal, nonDominated, allSolutions{i});
    end

    % Compute data for plotting
    finalFrontier = cell(nFinal, 1);
    delays = zeros(nFinal, 1);
    makespans = zeros(nFinal, 1);

    for i = 1:nFinal
        delays(i) = nonDominated{i}.weightedDelay;
        makespans(i) = nonDominated{i}.makespan;
        finalFrontier{i} = nonDominated{i};
    end
end