function [routers, usedRouters, xQtde,idxVizinhanca,indiceAtendimento] = neighborhoodChange(routers, newRouters,clients, usedRouters, xQtde, newUsedRouters, newQtde, idxVizinhanca, indiceAtendimento,newIndiceAtendimento)

% testa se a nova versao é melhor, se sim substitui, se nao, proxima
% vizinhanca
if newBetterThanOld(newRouters, clients, xQtde, newUsedRouters, newQtde, indiceAtendimento, newIndiceAtendimento) == true
    usedRouters = newUsedRouters;
    routers = newRouters;
    xQtde = newQtde;
    indiceAtendimento = newIndiceAtendimento;
else
    idxVizinhanca  = idxVizinhanca + 1;
end
end


function flag = newBetterThanOld(newRouters, clients, xQtde, newUsedRouters, newQtde, indiceAtendimento, newIndiceAtendimento)

flag = false;

qtdeRoutersInvalidos = obterQtdeRoutersInvalidos(newRouters, newUsedRouters, clients);

%verifica se a nova variacao é melhor que a anterior
if (((((newIndiceAtendimento > indiceAtendimento) || (newIndiceAtendimento == indiceAtendimento && newQtde < xQtde)) && indiceAtendimento < 0.95) || (indiceAtendimento >= 0.95 && newIndiceAtendimento >= indiceAtendimento && newQtde < xQtde)) && qtdeRoutersInvalidos == 0)
    disp("Índice de atendimentos válidos: " + newIndiceAtendimento*100 + "%");
    disp("Quantidade de PA's utilizados: " + newQtde);
    fprintf('\n')
    flag = true;
end


end

% retorna a quantidade de pontos de acesso que estao tendo a demanda maxima
% excedida
function qtdeRoutersInvalidos = obterQtdeRoutersInvalidos(routers, usedRouters, clients)
qtdeRoutersInvalidos = 0;
for idxRouter=1:length(routers)
    if usedRouters(idxRouter) == 1
        demandaRouter = 0;
        for idxClient=1:length(clients)
            if(testDistance(routers(idxRouter, 1), routers(idxRouter, 2), clients(idxClient, 1), clients(idxClient, 2)) == true)
                demandaRouter = demandaRouter + clients(idxClient, 3);
            end
        end
        if demandaRouter > 150
            qtdeRoutersInvalidos = qtdeRoutersInvalidos + 1;
        end
    end
end

end
