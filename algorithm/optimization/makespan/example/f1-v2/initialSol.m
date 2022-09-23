
function [routers, usedRouters] = initialSol()

maxRouters = 100;

% gera uma matriz 100x2 com posiçoes aleatorias pra cada router
routers = randi([0 800],maxRouters,2);

% gera um array 100x1 com 0's e 1's (boolean sinalizando se o router é
% usado ou nao)
usedRouters = randi([0 1],maxRouters,1); 