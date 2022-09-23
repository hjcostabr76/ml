function state = getStateVector(q, u1, t)

    %
    %======================================================================
    %
    % Implements the Two Carts (t) state vector.
    %
    % - q: Current State;
    % - u1: Current Input;
    % - t: Time instant;
    %
    % This script is built inspired by the Cord Model script of professor Antonio Aguirre.
    % Available in: TODO: ADD Link
    % 
    % Q' = AQ + Bu
    %
    %======================================================================
    %
    
    beta = 108.33;      % Linear approximation slope (linear eq 'a')
    lambda = 2*beta;    % Linear approximation 'b'
    linearBoundary = 2
    maxDisplacement = 5
    
    b = 0;      % Damping coefficient
    m1 = 2;     % 1st cart mass
    m2 = 2*m1;  % 2nd cart mass
    
    % Parse regions of each cart
    p1 = q(1);
    p2 = q(3);
    
    isRamp1 = abs(p1) > linearBoundary;
    isRamp2 = abs(p2) > linearBoundary;

    % Generate weight matrices
    nStates = length(q);

    A = zeros(nStates, nStates);
    B = zeros(nStates);

    if abs(p1) > maxDisplacement || abs(p2) > maxDisplacement
        % Out of established system domain

    elseif isRamp1 && isRamp2
        A(1, 2) = 1;
        
        A(2, 3) = beta / m1;
        A(2, 4) = b / m1;
        A(2, 5) = 1;

        A(3, 4) = 1;
        
        A(4, 1) = -beta / m2;
        A(4, 2) = -b / m2;
        A(4, 3) = beta / m2;
        A(4, 4) = b / m2;

        B(4) = 1 / m2;

    elseif isRamp1 && ~isRamp2
        A(1, 2) = 1;
        
        A(2, 3) = -beta / m1;
        A(2, 4) = 1 / m1;
        
        A(3, 4) = 1;
        
        A(4, 1) = beta / m2;
        A(4, 2) = b / m2;
        A(4, 4) = -b / m2;
        A(4, 5) = 1;

        B(4) = 1 / m2;

    elseif ~isRamp1 && isRamp2
        A(1, 2) = 1;
        
        A(2, 3) = -beta / m1;
        A(2, 4) = b / m1;
        A(2, 5) = 1 / m1;
        
        A(3, 4) = 1;
        
        A(4, 2) = -b / m2;
        A(4, 3) = beta / m2;
        A(4, 4) = b / m2;
        A(4, 5) = 1 / m2;

        B(4) = -1 / m2;

    else
        A(1, 2) = 1;
        A(2, 3) = b / m1;
        A(3, 4) = 1;
        
        A(4, 2) = -b / m2;
        A(4, 4) = b / m2;

        B(4) = 1 / m2;
    end
    
    % Update state
    for i = 1:nStates
        qD(i) = 0;
        for j = 1:nStates
            qD(i) = qD(i) + A(i, j)*q(j) + B(j)*u1;
        end
    end

    state = qD';
end