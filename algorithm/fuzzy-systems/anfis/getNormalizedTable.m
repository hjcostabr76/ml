function tableNorm = getNormalizedTable(table, columns)
    %
    %======================================================================
    %
    % Takes a table structure and a list of column names to make a new table
    % with all selected columns normalized into values from 0 to 100.
    %
    % PARAMS:
    % - table: Table strucuture to be normalized;
    % - columns: Table column names specifying which columns will be normalized;
    %
    % RETURN:
    % - tableNorm: Table structure with specified columns normalized; 
    %
    %======================================================================
    %
    
    tableNorm = table;
    nFeatures = length(columns);

    for i = 1:nFeatures
        column = columns(i);
        tableNorm{:, column} = 100 .* tableNorm{:, column} / max(tableNorm{:, column});
    end
end