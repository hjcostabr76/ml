clear all; clc; close all;

n = 2;
sampleSize = 8000;
m = [1 100 1000 10000]; % Interval between prbsBits
t = 1:1:sampleSize;
prbsBits = rand(1, n) > 0.5;

H = tf(1, [1000 1]);

for i = 1:length(m)
    
    %% Prepare graph
    figure(i); hold on;
    tiledlayout(2, 1);

    %% Generate PRBS
    prbs = getPRBS(sampleSize, n, m(i), prbsBits);
    
    ax = nexttile;
    title(ax, strcat("PRBS | T_b = ", string(m)));
    plot(ax, t, prbs, '-'); xlabel('t(s)'); ylabel('u(t)');
    
    %% Generate Response
    y = lsim(H, prbs, t);

    ax = nexttile;
    title(ax, strcat("y(t) | T_b = ", string(m)));
    plot(ax, t, y, '--r.'); xlabel('t(s)'); ylabel('y(t)');
    hold off;
end
