function [result, idxFirst, idxLast] = arrayTrim(array)
    %
    %======================================================================
    %
    % TODO: 2022-08-29 - ADD Description
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
   
    arrayLen = length(array);
    idxFirst = 1;
    idxLast = arrayLen;

    for i = 1:arrayLen
        if array(i) ~= 0
            idxFirst = i;
            break
        end
    end

    for i = arrayLen:-1:1
        if array(i) ~= 0
            idxLast = i;
            break
        end
    end
        
    result = array(idxFirst:idxLast);
    
end