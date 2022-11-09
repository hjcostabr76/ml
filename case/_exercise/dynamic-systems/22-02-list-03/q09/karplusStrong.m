function y = karplusStrong(x, alpha, M, nSamples)
    %
    %======================================================================
    %
    % TODO: 2022-11-08 - ADD Description
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
    
    y = zeros(1, nSamples);

    for n = 1:nSamples
        y(n) = x(n);

        if n > M
            y(n) = y(n) + alpha*y(n - M);
        end
    end
    
end