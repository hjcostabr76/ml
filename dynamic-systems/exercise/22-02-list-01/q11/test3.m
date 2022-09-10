clear; close all; clc;

[alpha,V] = ndgrid(0:1.5:15,300:30:600);
domain = struct('alpha',alpha,'V',V);
shapefcn = @(x,y) [x,y,x*y];
GS = tunableSurface('GS',ones(2,2),domain,shapefcn);

K0 = 10*rand(2);
K1 = 10*rand(2);
K2 = 10*rand(2);
K3 = 10*rand(2);

alpha_vec = [7:1:13];  % N1 = 7 points
V_vec = [400:25:625];  % N2 = 10 points
GV = evalSurf(GS,alpha_vec,V_vec,'gridlast');

size(GV)