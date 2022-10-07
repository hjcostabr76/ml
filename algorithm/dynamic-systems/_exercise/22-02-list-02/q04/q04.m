close all; clear; clc;

N = 5;
alphaP = .25; % dB

% Initialize with filter order & pass band ripple parameters
[z,p,k] = cheb1ap(N, alphaP);

% Set transfer function
[num, den] = zp2tf(z, p, k);
sys = tf(num, den);

% Plot: zero pole map
pzplot(sys);