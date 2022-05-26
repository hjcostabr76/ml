
function sol = initialSol()

maxRouters = 100;

sol.meta = 0.95; % indice minimo de clientes com suas demandas integralmente atendidas

sol.eps = false; % bool para informar se esta solução está sendo executada a partir do epsilon restrito
sol.restricao = 0;

% gera uma matriz 100x2 com posiçoes aleatorias pra cada router
sol.routers = randi([0 800],maxRouters,2);

% gera um array 100x1 com 0's e 1's (boolean sinalizando se o router é
% usado ou nao)
sol.usedRouters = randi([0 1],maxRouters,1); 