function sigmaE = getBestSigmaE(sigmaY)
    %
    %======================================================================
    %
    % TODO: 2022-02-19 - ADD Description
    %
    % PARAMS:
    % - sigmaY: Standard deviation of the clean output.
    %
    % RETURN:
    % - sigmaE: Ideal standard deviation value for the noise;
    %
    %======================================================================
    %
    
    getSNR = @(sigmaY, sigmaE) 20*log10(sigmaY / sigmaE);

    sigmaE = 1;
    while getSNR(sigmaY, sigmaE) < 10
        sigmaE = sigmaE - .05;
    end
end