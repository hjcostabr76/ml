function b = getBayes(ds, param)
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
    b = length(ds) * log(var(ds)) + param*log(length(ds));
end
