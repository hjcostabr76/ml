function [y,newRouters] = shake(routers, usedRouters,idxVizinhanca)

%armazena o estado atual
y = usedRouters;
n = length(usedRouters);
r = randperm(n);
newRouters = routers;

%pega posicoes aleatorias dos utilizados e inverte o uso desses routers
y(r(1:idxVizinhanca*3)) = not(usedRouters(r(1:idxVizinhanca*3)));
% altera as posiçoes de alguns roteadores de forma aleatoria
newRouters(r(1:idxVizinhanca*2), :) = randi([0 800],idxVizinhanca*2,2);