function y = getOutput(x, u1, t)

    %
    %======================================================================
    %
    % Implements the Two Carts x(t) output vector.
    % -- The model is defined on file 'twoCartsModel.m' --
    %
    % - x: Current State;
    % - u1: Current Input;
    %
    % This script is built inspired by the Cord Model script of professor Antonio Aguirre.
    % Available in: TODO: ADD Link
    %
    %======================================================================
    %
    
    % Y = CX + Du
    c15 = .9559;
    c25 = -.9559;
    d1 = -1.087;
    d2 = 1.087;

    y1(1) = c15*x(5) + d1*u1;
    y1(2) = c25*x(5) + d2*u1;
    
    y = y1';
end