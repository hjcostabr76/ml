function state = getStateVector(x, u1, t)

    %
    %======================================================================
    %
    % Implements the Two Carts x(t) state vector.
    % -- The model is defined on file 'twoCartsModel.m' --
    %
    % - x: Current State;
    % - u1: Current Input;
    % - t: Time instant;
    %
    % This script is built inspired by the Cord Model script of professor Antonio Aguirre.
    % Available in: TODO: ADD Link
    %
    %======================================================================
    %
    
    % X' = AX + Bu
    b11 = 2;

    a15 = -1.759;
    a21 = 2;
    a32 = 1;
    a43 = 1;
    a54 = 1;
    
    xD(1) = a15*x(5) + b11*u1;
    xD(2) = a21*x(1);
    xD(3) = a32*x(2);
    xD(4) = a43*x(3);
    xD(5) = a54*x(4);

    state = xD';
end