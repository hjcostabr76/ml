function x = getRungeKutta(x0, u1, h, t)

    %
    %======================================================================
    %
    % Numerical integration algorithm: 4th-order Runge-Kutta
    % Application for the two carts system.
    % 
    % - x0 State vector BEFORE calling the function (i.e. initial condition at each integration step);
    % - u1: External force (control action) applied over the 2nd cart (Assuming it do NOT change during integrarion period h
    % - h: Integration interval;
    % - t: Time BEFORE calling the function;
    %
    % This script is built inspired by the Cord Model script of professor Antonio Aguirre.
    % Available in: TODO: ADD Link
    %
    %======================================================================
    %
    
    % 1st evaluation
    xD = getStateVector(x0, u1, t);
    savex0 = x0;
    phi = xD;
    x0 = savex0 + 0.5*h*xD;
    
    % 2nd evaluation
    xD = getStateVector(x0, u1, t+0.5*h);
    phi = phi + 2*xD;
    x0 = savex0 + 0.5*h*xD;
    
    % 3rd evaluateReaction(structuralresults, RegionType, RegionID)
    xD = getStateVector(x0, u1, t+0.5*h);
    phi = phi + 2*xD;
    x0 = savex0 + h*xD;
    
    % 4th evaluation
    xD = getStateVector(x0, u1, t+h);
    x = savex0 + (phi+xD)*h / 6;
end