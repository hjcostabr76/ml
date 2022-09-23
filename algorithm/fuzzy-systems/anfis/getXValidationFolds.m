function folds = getXValidationFolds(X, Y, trainRate, k)
    %
    %======================================================================
    %
    % TODO: 2022-02-09 - ADD Description
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
    
    nRows = size(X, 1);
    nFold = floor(nRows / k);
    nTrain = round(trainRate * nFold);
    
    folds = cell(k, 1);
    availableIdx = 1:1:nRows;

    for i = 1:k

        trainIdx = randsample(availableIdx, nTrain);
        availableIdx = availableIdx(setdiff(1:end, trainIdx));

        fold.xTrain = X(trainIdx, :);
        fold.yTrain = Y(trainIdx, :);
        fold.xTest = X(setdiff(1:end, trainIdx), :);
        fold.yTest = Y(setdiff(1:end, trainIdx), :);
        
        folds{i} = fold;
    end 
end