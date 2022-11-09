function y = frequencyFiltering(x, h)
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
    
    h = [h zeros(1, nX - 1)];
    x = [x zeros(1, nH - 1)];

    X = fft(x, nY);
    H = fft(h, nY);
    Y = X .* H;

    y = ifft(Y, nY);
end
