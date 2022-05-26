function [objParams, k, haveImproved] = neighborhoodChange(prevParams, newParams, k);
    if newParams.target < prevParams.target
        k = 1;
        objParams = newParams;
        haveImproved = true;
    else
        objParams = prevParams;
        k  = k + 1;
        haveImproved = false;
    end
end
