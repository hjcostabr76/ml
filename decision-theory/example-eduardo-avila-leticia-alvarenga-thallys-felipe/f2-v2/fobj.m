
function [mediaGeral, indiceClientesValidos] = fobj(routers, usedRouters, clients)
mediaGeral = 0;
qtdeRoteadoresUtilizados = 0;

%calcula a media geral de distancias da soluçao corrente
for idxRouter=1:length(routers)
    if usedRouters(idxRouter) == 1
        qtdeRoteadoresUtilizados = qtdeRoteadoresUtilizados + 1;
        qtdeUsosRouter = 0;
        distTotalRouter = 0;
        for idxClient=1:length(clients)
            dist = distancia(routers(idxRouter, 1), routers(idxRouter, 2), clients(idxClient, 1), clients(idxClient, 2));
            if(dist < 85)
                qtdeUsosRouter = qtdeUsosRouter + 1;
                distTotalRouter = distTotalRouter + dist;
            end
        end
        if qtdeUsosRouter > 0
            mediaGeral = mediaGeral + distTotalRouter/qtdeUsosRouter;
        end
    end
end

mediaGeral = mediaGeral/qtdeRoteadoresUtilizados;

% obtem o indice de atendimentos validos
indiceClientesValidos = (obterQtdeClientesValidos(routers, usedRouters, clients)/length(clients));
