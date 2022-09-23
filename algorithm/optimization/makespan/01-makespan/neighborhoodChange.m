function [maxTime, taskDistribution, machineTimes, k, haveChanged] = neighborhoodChange(maxTime, taskDistribution, machineTimes, newMaxTime, newDistribution, newMachineTimes, k);


    %
    % ===================================================================
    % -------------------------------------------------------------------
    % TODO: ADD Description
    %
    % -------------------------------------------------------------------
    % ===================================================================
    %

    if newMaxTime < maxTime
        disp("Best time: " + newMaxTime);
        fprintf('\n')
        maxTime = newMaxTime;
        machineTimes = newMachineTimes;
        taskDistribution = newDistribution;
        haveChanged = true;
    else
        haveChanged = false;
        k  = k + 1;
    end
end
