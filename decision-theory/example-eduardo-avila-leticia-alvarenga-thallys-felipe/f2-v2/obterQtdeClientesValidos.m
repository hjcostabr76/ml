function qtdeClientesValidos = obterQtdeClientesValidos(routers, usedRouters, clients)
qtdeClientesValidos = 0;
% para cada cliente itera entre os routers utilizados pra verificar se o
% cliente é atendido
for idxClient=1:length(clients)
    
    qtdeAtendimentos = 0;
    
    for idxRouter=1:length(routers)
        %mesma verificacao acima mas pra formacao corrente
        if usedRouters(idxRouter) == 1
            if(distancia(routers(idxRouter, 1), routers(idxRouter, 2), clients(idxClient, 1), clients(idxClient, 2)) < 85)
                qtdeAtendimentos = qtdeAtendimentos + 1;
            end
        end
    end
    
    if qtdeAtendimentos == 1
        qtdeClientesValidos = qtdeClientesValidos + 1;
    end
    
end
end