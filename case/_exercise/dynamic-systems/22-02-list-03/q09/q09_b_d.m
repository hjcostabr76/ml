close all; clear; clc;

M = 3;

N = M;
nPeriods = 10;
nSamples = nPeriods*N;

delta = zeros(1, nSamples);
delta(1) = 1;

% Letter B
figure;
alpha = 1;
x = delta;
y = karplusStrong(x, alpha, M, nSamples);
plotKarplusStrong(x, y, alpha, 1);

% Letter C
figure;
alpha = .7;
y = karplusStrong(x, alpha, M, nSamples);
plotKarplusStrong(x, y, alpha, 1);

% Letter D
figure;

xHat = zeros(1, nSamples);
for n = 1:nSamples
    xHat(n) = delta(n);

    if n > 1
        xHat = xHat + 2*delta(n - 1);
    end
    
    if n > 2
        xHat = xHat + 3*delta(n - 2);
    end
end


y = karplusStrong(xHat, alpha, M, nSamples);
plotKarplusStrong(x, y, alpha, 1);