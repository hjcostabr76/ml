function showData(solutions)
    %
    %======================================================================
    %
    % TODO: 2022-01-18 - ADD Description
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
   
    for i = 1:length(solutions)
        sol = solutions{i};
        aux1 = strcat(string(i - 1), " - ", sol.id, ":  wCost = ", string(solutions{i}.cost));
        aux2 = strcat(" maxTime = ", string(sol.maxTime), ";    delay = ", string(sol.weightedDelay));
        aux3 = strcat(" advance = ", string(sol.weightedAdvance), ";    advance reverted: ", string(sol.wAdvanceReverted));
        disp(strcat(aux1, aux2, aux3));
    end
end