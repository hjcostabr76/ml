function U = getU(u)
    %
    %======================================================================
    %
    % TODO: 2022-01-08 - ADD Description
    %
    % PARAMS:
    %    - TODO: Describe params
    %======================================================================
    %

    mSize = length(u);
    U = zeros(mSize);
    
    for i = 1:mSize
        for j = 1:mSize
            idx = i - j + 1;
            if idx > 0
                U(i, j) = u(idx);
            else
                U(i, j) = 0;
            end
        end
    end
end