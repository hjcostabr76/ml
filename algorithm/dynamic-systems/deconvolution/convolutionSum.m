function sum = convolutionSum(k, kMax)
    %
    %======================================================================
    %
    % TODO: 2022-01-08 - ADD Description
    %
    %======================================================================
    %
    
    sum = 0;

    for j = 1:kMax
        uIdx = k - j;
        if uIdx >= 1
            sum = sum + h(j) * u(uIdx);
        end
    end
end