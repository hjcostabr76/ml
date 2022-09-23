%
%======================================================================================
%
% This file is used to build the model of two two carts system.
%
% Properties of the 1st cart aren't relevant for the laplace transform of
% the 2nd state equation (which is the one that relates 02 outputs -> 01 input of the system).
%======================================================================================
%

% Set parametrers of the Laplace transformed state equations
% alpha1 = .5;
% k1 = .988;
% b1 = 1.1;

alpha2 = .6;
k2 = .899;
b2 = .92;

% Crete transfer functions: Cart 01
tFunc1N = [-1 0 0 0 0 0];
tFunc1D = [b2 0 0 0 0 6*k2*alpha2];
tFunc1 = tf(tFunc1N, tFunc1D);

% Crete transfer functions: Cart 02
tFunc2N = [1 0 0 0 0 0];
tFunc2D = [b2 0 0 0 0 6*k2*alpha2];
tFunc2 = tf([1 0 0 0 0 0], [1 0 0 0 0 0]);

% Space state representation
H = [tFunc1; tFunc2];
sState = ss(H);