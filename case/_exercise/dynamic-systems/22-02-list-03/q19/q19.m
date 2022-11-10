close all; clear; clc;

plotPzMap([1 -.9], 1);
plotPzMap([1 +.9], 2);

plotPzMap([1 0 -.81], 3);
plotPzMap([1 0 +.81], 4);

plotPzMap([1 1.8*cos(45) +.81], 5);
plotPzMap([1 -1.8*cos(45) +.81], 6);

function result = plotPzMap(polyDenominator, i)
    %
    %======================================================================
    %
    % TODO: 2022-11-09 - ADD Description
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
    
    fs = 1;
    H = tf([1 0], polyDenominator, fs);
    
    figure;
    pzmap(H);
    title('$Y_' + string(i) + '(z)$', 'Interpreter', 'latex');
    saveas(gcf, 'l3-q19-graph-0' + string(i) + '.png');
    
end