function [memoryfile] = VNS()

testCount = 0;
% obtem uma primeira soluçao aleatoria
[routers, usedRouters] = initialSol();
%carrega a lista de pontos de demanda
clients = csvread('clientes.csv');
% testa a primeira soluçao aleatoria na funçao objetivo
[xQtde, indiceAtendimento] = fobj(routers, usedRouters, clients);
% armazena a primeira soluçao pra plotar depois
memoryfile(1,:) = [usedRouters(:)' xQtde];
% maximo de vizinhancas definido
maxVizinhancas = 10;
testTotal = 0;
% executa os testes
while (testCount < 12000 || indiceAtendimento < 0.95)
    idxVizinhanca = 1;
    testTotal = testTotal + 1;
    % executa as variaçoes de vizinhanca
    while (idxVizinhanca <= maxVizinhancas)
        % shake pra obter uma variaçao
        [newUsedRouters, newRouters] = shake(routers, usedRouters,idxVizinhanca);
        % testa a variaçao na funçao objetivo
        [newQtde, newIndiceAtendimento] = fobj(newRouters, newUsedRouters, clients);
        
        % verifica se a nova variaçao é melhor que a anterior, se sim,
        % substitui o a anterior pela nova
        [routers, usedRouters, xQtde,idxVizinhanca, indiceAtendimento] = neighborhoodChange(routers, newRouters, clients, usedRouters, xQtde, newUsedRouters, newQtde, idxVizinhanca, indiceAtendimento, newIndiceAtendimento);
        % armazena a soluçao pra plotagem
        memoryfile(size(memoryfile,1)+1,:) = [usedRouters(:)' xQtde];
        if indiceAtendimento >= 0.95
            testCount = testCount + 1;
        end
    end
    
    % se a soluçao corrente nao estiver atendendo à restriçao de 95% dos
    % pontos atendidos apos um determinado numero de execuções, reinicia-se
    % os valores desta
    if (testTotal == 4000 && indiceAtendimento < 0.93)|| (testTotal == 7500 && indiceAtendimento < 0.94) || (testTotal == 14000 && indiceAtendimento < 0.95)
        [routers, usedRouters] = initialSol();
        [xQtde, indiceAtendimento] = fobj(routers, usedRouters, clients);
        memoryfile = [];
        testTotal = 0;
    end
end

