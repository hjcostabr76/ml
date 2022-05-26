function params = getRecursiveEstimation(u, y, nParams, ini, lambda)
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
    
    psi = eye(nParams) * 10^6;
    theta(:, ini - 1) = ones(nParams, 1);

    for k = ini:length(y)

        % Loren Ipsul
        psiK = ones(nParams, 1);

        aux = nParams / 2;
        for i = 1:aux
            psiK(i) = y(k - i);
            psiK(aux + i) = u(k - i);
        end

        K_k = psi*psiK / ( psiK'*psi*psiK + lambda ); 
        theta(:, k) = theta(:, k - 1) + K_k*( y(k) - psiK'*theta(:, k - 1) );
        psi = (psi - psi*psiK*psiK'*psi / ( psiK'*psi*psiK + lambda )) / lambda;
    end

    params = theta(:, end);
end
