clear all; clc; close all;

N = 250;
n = 6;
m = [2, 4, 6, 8]; % Interval between bits
t = 1:1:N;
bits = rand(1, n) > 0.5;

for i = 1:length(m)

    %% Generate PRBS
    prbs = getPRBS(N, n, m(i), bits);
    figure(i); hold on;
    plot(t, prbs, '-o'); xlabel('t(s)'); ylabel('y(t)');
    hold off;

    %% Generate FAC
    figure(i + length(m)); hold on;
    myccf([prbs' prbs'], 10, 0, 1, 'b');
    hold off;
end
