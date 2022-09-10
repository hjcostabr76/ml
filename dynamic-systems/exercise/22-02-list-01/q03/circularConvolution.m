function y = circularConvolution(x, h)
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
    
    nX = length(x);
    nH = length(h);
    nY = nX + nH - 1;
    
    h = flip([h zeros(1, nX - 1)]);
    x = [x zeros(1, nH - 1)];

    y = zeros(1, nY);
    for n = 1:nY
        % aux = circshift(h, n - 1)';
        aux = circshift(h, n)';
        % y(n) = x * circshift(h, n - 1)';
        y(n) = x * aux;
    end
end
