close all; clear; clc;

b = [.1616 .3026 .1616];
a = [1 -.6754 .3775];

fs = 1;
H = tf(b, a, fs);

%% Zero pole map
figure;
pzmap(H);
