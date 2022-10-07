close all; clear; clc;

N = 3;
wc = 40;

[z, p, k] = buttap(N);
[num, den] = zp2tf(z, p, k);
sys = tf(wc*num, wc*den);
pzplot(sys);
