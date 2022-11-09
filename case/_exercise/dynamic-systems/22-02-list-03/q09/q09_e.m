close all; clear; clc;

M = 100;

N = M;
nPeriods = 10;
nSamples = nPeriods*N;

n = 0:M-1;
x = zeros(1, nSamples);

% Sine
figure;
alpha = .995;

x(1:M) = sin(2*pi*(n)/N);
y = karplusStrong(x, alpha, M, nSamples);
plotKarplusStrong(x, y, alpha, 0);

% Squared
figure;
alpha = .95;

x(1:M/2) = -1;
x((M/2 + 1):M) = 1;
y = karplusStrong(x, alpha, M, nSamples);
plotKarplusStrong(x, y, alpha, 0);

% Saw
figure;
alpha = 1;

x(1:M) = 2*n/M - 1;
y = karplusStrong(x, alpha, M, nSamples);
plotKarplusStrong(x, y, alpha, 0);

% White Noise
figure;
alpha = .995;

x(1:M) = randn(1, M);
y = karplusStrong(x, alpha, M, nSamples);
plotKarplusStrong(x, y, alpha, 0);