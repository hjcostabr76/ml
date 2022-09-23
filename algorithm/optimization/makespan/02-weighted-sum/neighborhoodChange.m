function [somaPonderadaAtrasos, taskDistribution, k, haveChanged] = neighborhoodChange(somaPonderadaAtrasos, taskDistribution, newSomaPonderadaAtrasos, newDistribution, k)


    %
    % ===================================================================
    % -------------------------------------------------------------------
    % TODO: ADD Description
    %
    % -------------------------------------------------------------------
    % ===================================================================
    %

    if newSomaPonderadaAtrasos <= somaPonderadaAtrasos
        disp("Best time: " + newSomaPonderadaAtrasos);
        fprintf('\n')
        somaPonderadaAtrasos = newSomaPonderadaAtrasos;
        taskDistribution = newDistribution;
        haveChanged = true;
    else
        haveChanged = false;
        k  = k + 1;
    end
end
