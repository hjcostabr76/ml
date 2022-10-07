close all; clear; clc;

%% BPF made directly
num = [20 0];
den = [1 20 800];
H1  = tf(num, den);

figure(1);
bodeplot(H1);
title('BPF');
grid on;

%% BPF made by LPF + HPF combination
num = [40 0];
den = [1 60 800];
H2  = tf(num, den);

figure(2);
bodeplot(H2);
title('LPF + HPF');
grid on;
