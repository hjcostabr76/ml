function sol = VNSw(sol, clients)

% testa a primeira solu�ao aleatoria na fun�ao objetivo
sol = fobjw(sol, clients);


% maximo de vizinhancas definido
maxVizinhancas = 6;
testTotal = 0;
testCount = 0;

% executa os testes
while (testCount < 12000 || sol.indiceAtendimento < sol.meta)
    idxVizinhanca = 1;
    testTotal = testTotal + 1;

    % executa as varia�oes de vizinhanca
    while (idxVizinhanca <= maxVizinhancas)
        
        % shake pra obter uma varia�ao
        newSol = shake(sol,idxVizinhanca);
        % testa a varia�ao na fun�ao objetivo
        newSol = fobjw(newSol, clients);
        
        % verifica se a nova varia�ao � melhor que a anterior, se sim,
        % substitui o a anterior pela nova
        [sol, idxVizinhanca] = neighborhoodChange(sol, newSol, idxVizinhanca);
        if sol.indiceAtendimento >= sol.meta
            testCount = testCount + 1;
        end
    end
    
    % se a solu�ao corrente nao estiver atendendo � restri�ao de 95% dos
    % pontos atendidos apos um determinado numero de execu��es, reinicia-se
    % os valores desta
    if (testTotal == 4000 && sol.indiceAtendimento < (sol.meta-0.02))|| (testTotal == 7500 && sol.indiceAtendimento < (sol.meta-0.01)) || (testTotal == 10000 && sol.indiceAtendimento < sol.meta)
        pesos = sol.pesos;
        eps = sol.eps;
        restricao = sol.restricao;
        sol = initialSol();
        sol.restricao = restricao;
        sol.eps = eps;
        sol.pesos = pesos;
        sol = fobjw(sol, clients);
        testTotal = 0;
    end
end
