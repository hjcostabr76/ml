
function [qtde, indiceClientesValidos] = fobj(routers, usedRouters, clients)
qtde = 0;
% armazena em QTDE a quantidade de routers usados
for i=1:length(usedRouters)
    if(usedRouters(i) == 1)
        qtde = qtde + 1;
    end
end

indiceClientesValidos = (obterQtdeClientesValidos(routers, usedRouters, clients)) / length(clients);