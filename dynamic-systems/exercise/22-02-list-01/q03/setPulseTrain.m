

function [t, x] = setPulseTrain(T)
    %
    %======================================================================
    %
    % TODO: 2022-09-06 - ADD Description
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
       
    % T = 4;
    t = -2*T:2*T;
    x = zeros(1, length(t));

    for i = 1:length(t)
        if ~mod(t(i), T)
            x(i) = 1;
        end
    end

    stem(t, x);
    xlim([t(1) - 1, t(end) + 1]) 

end