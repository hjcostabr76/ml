function yHat = getOneStepAheadY(u, y, params, ini)
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
    
    nParams = length(params);
    params = reshape(params, 1, nParams)
    yHat = zeros(nParams - ini, 1);

    for k = ini:length(y)

        auxU = ones(1, nParams / 2);
        auxY = ones(1, nParams / 2);

        for i = 1:(nParams / 2)
            auxU(i) = u(k - i);
            auxY(i) = y(k - i);
        end

        yHat(k) = dot([auxY auxU], params);
    end
end


yHatStep = zeros([1, length(yTestDec)]);
for k = ini:length(yTestDec)
    yHatStep(k) = dot([yTestDec(k-1), yTestDec(k-2), yTestDec(k-3), yTestDec(k-4), yTestDec(k-5), uTestDec(k-1), uTestDec(k-2), uTestDec(k-3), uTestDec(k-4), uTestDec(k-5)], params);
end