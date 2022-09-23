
function y = shake(x)

    %
    % ===================================================================
    % TODO: ADD Description
    % -------------------------------------------------------------------
    %
    % -------------------------------------------------------------------
    % ===================================================================
    %

    [tasksCount, machinesCount] = size(x);
    y = x;
    y = changeColumns(y, machinesCount);
    y = changeLines(y, tasksCount);
    
    errorsCount = 0;
    while ~isRestrictionsValid(y)
        y = changeColumns(y, machinesCount);
        y = changeLines(y, tasksCount);
        
        errorsCount = errorsCount + 1;
        if errorsCount > 10
            throw (MException('myComponent:InputError', 'Shake is struggling to find a valid alternative...'))
        end
    end
end

function y = changeColumns(y, columnsCount)

    j1 = 1;
    j2 = 1;
    while j1 == j2
        j1 = randi(columnsCount);
        j2 = randi(columnsCount);
    end
    
    aux1 = y(:, j1);
    y(:, j1) = y(:, j2);
    y(:, j2) = aux1;
end

function y = changeLines(y, linesCount)
    
    i1 = 1;
    i2 = 1;
    while i1 == i2
        i1 = randi(linesCount);
        i2 = randi(linesCount);
    end
    
    aux1 = y(i1, :);
    y(i1, :) = y(i2, :);
    y(i2, :) = aux1;
end