function plotKarplusString(x, y, alpha, isDiscrete)
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
    
    subplot(2, 1, 1);
    if isDiscrete
        stem(x);
    else
        plot(x);
    end

    title('Karplus-Strong $\alpha = ' + string(alpha) + '$', 'Interpreter', 'latex');
    ylabel('x[n]');
    xlabel('n');

    grid on;
    
    subplot(2, 1, 2);if isDiscrete
        stem(y);
    else
        plot(y);
    end
    
    title('Karplus-Strong $\alpha = ' + string(alpha) + '$', 'Interpreter', 'latex');
    ylabel('y[n]');
    xlabel('n');
    grid on;
    
end