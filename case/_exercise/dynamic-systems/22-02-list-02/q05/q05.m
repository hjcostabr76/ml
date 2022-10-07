close all; clear; clc;

% N = input('Insert filter order: ');

alpha_s = 60; 
alpha_p = 0.5; 
omega_p = 2*pi*500;

% parseChebyshev2(N, alpha_p, alpha_s, omega_p);

for N = 1:6
    parseChebyshev2(N, alpha_p, alpha_s, omega_p);
    hold on; 
end


function [omega_s, z, p, H] = parseChebyshev2(N, alpha_p, alpha_s, omega_p)
    %
    %======================================================================
    %
    % TODO: 2022-10-04 - ADD Description
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
    
    % Rejection band border frequency
    aux = (sqrt(10^(alpha_p / 10) - 1)) * (sqrt(10^(alpha_p / 10) - 1));
    omega_s = omega_p * cosh((1 / N) * acosh(1 / aux));

    % Zeros & poles
    [z, p, k] = cheby2(N, alpha_s, omega_s,'S');
    
    % Transfer function
    [num, den] = cheby2(N, alpha_s, omega_s,'S'); 
    H = tf(num, den);

    % Plots
    figure;
    pzmap(H);

    figure;
    bode(num, den);

end