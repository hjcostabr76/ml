
function sol = fobjw(sol, clients)

sol.qtde = 0; % quantidade de roteadores utilizados
sol.distanciaMedia = 0; % distancia media entre os roteadores e os clientes atendidos por eles
sol.qtdeRoutersInvalidos = 0; % numero de roteadores que excedem a demanda limite (150 MB)

%calcula a media geral de distancias da solu�ao corrente
qtdeUsosRouter = 0;
distTotalRouter = 0;

for idxRouter=1:length(sol.routers) % itera em todos os routers pra verificar se algum � invalido avaliar a distancia e quantidade utilizada
    if sol.usedRouters(idxRouter) == 1
        sol.qtde = sol.qtde + 1;
        demandaRouter = 0;
        for idxClient=1:length(clients)
            dist = distancia(sol.routers(idxRouter, 1), sol.routers(idxRouter, 2), clients(idxClient, 1), clients(idxClient, 2));
            if(dist < 85) % verifica se o cliente � atendido pelo router
                qtdeUsosRouter = qtdeUsosRouter + 1; % incrementa o uso 
                distTotalRouter = distTotalRouter + dist; % incrementa pro calculo de distancia media
                demandaRouter = demandaRouter + clients(idxClient, 3); % incrementa pra verificar se est� excedendo a demanda m�xima
            end
        end

        if demandaRouter > 150
            sol.qtdeRoutersInvalidos = sol.qtdeRoutersInvalidos + 1;
        end
    end
end

sol.distanciaMedia = (distTotalRouter/qtdeUsosRouter);
sol.indiceAtendimento = (obterQtdeClientesValidos(sol, clients))/length(clients); % verifica a porcentagem de clientes validos que est�o sendo atendidos

normaDistancia = (sol.distanciaMedia - 0)/(85 -0); % normaliza��o da distancia media
normaRoteadores = (sol.qtde -1)/(100-1); % normaliza��o da quantidade de roteadores
sol.avaliacao = normaRoteadores*sol.pesos(1) + normaDistancia*sol.pesos(2); % indice para avaliar a solu��o, quanto menor melhor