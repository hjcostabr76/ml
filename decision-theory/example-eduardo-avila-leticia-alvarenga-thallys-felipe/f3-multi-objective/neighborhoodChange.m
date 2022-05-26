function [sol, idxVizinhanca] = neighborhoodChange(sol, newSol, idxVizinhanca)

% testa se a nova versao � melhor, se sim substitui, se nao, proxima
% vizinhanca
if newBetterThanOld(sol, newSol) == true
    sol = newSol;
    idxVizinhanca = 1;
else
    idxVizinhanca  = idxVizinhanca + 1;
end
end


function flag = newBetterThanOld(sol, newSol)

flag = false;

if sol.qtdeRoutersInvalidos > 0 % verifica se nao possui nenhum roteador com demanda excedida
    flag = false;
elseif sol.indiceAtendimento < sol.meta && ((newSol.indiceAtendimento > sol.indiceAtendimento) || (newSol.indiceAtendimento == sol.indiceAtendimento && (newSol.avaliacao <= sol.avaliacao))) % avaliacao para verificar se esta atendendo a restri�ao minima, e evoluir as solu��es a medida que n�o atende as restri��es minimas
    flag = true;
elseif (~sol.eps) && sol.indiceAtendimento >= sol.meta && newSol.indiceAtendimento >= sol.meta && newSol.avaliacao <= sol.avaliacao % se nao for execu�ao epsilon restrito, avalia somente o indice de avaliacao de cada solu��o
    flag = true;
elseif sol.eps && newSol.distanciaMedia <= (sol.restricao*1.05) && newSol.indiceAtendimento >= sol.meta && newSol.avaliacao <= sol.avaliacao % se for execu��o epsilon restrio, alem do indice de avalia�ao tamb�m verifica se est� obedecendo a nova restri��o imposta pelo metodo aplicado
    flag = true;
end

if flag % if apenas para verificar a evolu��o do algoritmo
    disp("�ndice de atendimentos v�lidos: " + newSol.indiceAtendimento*100 + "%");
    disp("Quantidade de PA's utilizados: " + newSol.qtde);
    disp("Dist�ncia m�dia: " + newSol.distanciaMedia);
    disp("Avalia��o: " + newSol.avaliacao);
    disp("Hor�rio: " + datestr(now, 'HH:MM'));
    fprintf('\n')
end

end
