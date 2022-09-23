function [err1, err2] = getRMSE(y, yHatStep, yHatFree)
    %
    %======================================================================
    %
    % TODO: 2022-02-20 - ADD Description
    %
    % HOW TO CALL:
    % - TODO: Describe how to call it
    %
    % PARAMS:
    % - TODO: Describe params
    %
    % RETURN:
    % - TODO: Describe return
    %
    % AUTHOR:
    % - TODO: Set author name
    %
    %======================================================================
    %

    nSample = length(y);
    err1 = 0;
    err2 = 0;

    for k = 1:length(y)
        err1 = err1 + (y(k) - yHatStep(k)')^2 / nSample;
        err2 = err2 + (y(k) - yHatFree(k)')^2 / nSample;
    end
end
