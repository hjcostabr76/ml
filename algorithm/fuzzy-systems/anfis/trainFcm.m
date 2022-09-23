function [fis, nClusters, accuracy] = trainFcm(foldNumber, clusters, fold, getYHat, getAccuracy)
    %
    %======================================================================
    %
    % Returns a FIS initialized with Fuzzy C-Means method.
    % - It takes a list of clusters counts to be tested and returns the version whose number of
    % clusters lead to the best outcomes.
    %
    % PARAMS:
    % - foldNumber: Identification of this function execution;
    % - clusters: List of possible numbers of clusters to be tested;
    % - fold: Cross validation fold holding input and output values split for train and test;
    % - getYHat: Function that takes a FIS & an input test and return the corresponding approximated outputs;
    % - getAccuracy: Function that takes a set of approximated along with a set of test output values and return the accuracy;
    %
    % RETURN:
    % - fis: The best FIS among the experimented ones (one for each clusters count);
    % - nClusters: The number of clusters for which the best FIS was found;
    % - accuracy: The best FIS accuracy;
    %
    %======================================================================
    %

    best.fis = -1;
    best.nClusters = 1;
    best.accuracy = 0;

    for i = 1:length(clusters)
    
        % Classifiy
        nClusters = clusters(i);
        
        cfg = genfisOptions('FCMClustering');
        cfg.FISType = 'sugeno';
        cfg.NumClusters = nClusters;
        cfg.Verbose = 0;
        
        fis = genfis(fold.xTrain, fold.yTrain, cfg);
        % showrule(fis)
        yHat = getYHat(fis, fold.xTest);
        accuracy = getAccuracy(yHat, fold.yTest);

        if accuracy > best.accuracy
            best.fis = fis;
            best.nClusters = nClusters;
            best.accuracy = accuracy;
        end

        disp(strcat('[trainFcm] (', string(i) ,') fold #', string(foldNumber), ': ', string(nClusters), ' ', ' clusters, ', string(accuracy), '% accuracy'));
    end

    % Set return values
    fis = best.fis;
    accuracy = best.accuracy;
    nClusters = best.nClusters;
end
