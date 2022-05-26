function newSol = shake(sol,idxVizinhanca)

newSol = sol;

n = length(sol.usedRouters);
r = randperm(n);

%pega posicoes aleatorias dos utilizados e inverte o uso desses routers
newSol.usedRouters(r(1:idxVizinhanca*3)) = not(sol.usedRouters(r(1:idxVizinhanca*3)));
% altera as posiçoes de alguns roteadores de forma aleatoria
newSol.routers(r(1:idxVizinhanca*2), :) = randi([0 800],idxVizinhanca*2,2);