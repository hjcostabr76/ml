function [sol, idxVizinhanca] = neighborhoodChange(sol, newSol, idxVizinhanca)

% testa se a nova versao é melhor, se sim substitui, se nao, proxima
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
elseif sol.indiceAtendimento < sol.meta && ((newSol.indiceAtendimento > sol.indiceAtendimento) || (newSol.indiceAtendimento == sol.indiceAtendimento && (newSol.avaliacao <= sol.avaliacao))) % avaliacao para verificar se esta atendendo a restriçao minima, e evoluir as soluções a medida que não atende as restrições minimas
    flag = true;
elseif (~sol.eps) && sol.indiceAtendimento >= sol.meta && newSol.indiceAtendimento >= sol.meta && newSol.avaliacao <= sol.avaliacao % se nao for execuçao epsilon restrito, avalia somente o indice de avaliacao de cada solução
    flag = true;
elseif sol.eps && newSol.distanciaMedia <= (sol.restricao*1.05) && newSol.indiceAtendimento >= sol.meta && newSol.avaliacao <= sol.avaliacao % se for execução epsilon restrio, alem do indice de avaliaçao também verifica se está obedecendo a nova restrição imposta pelo metodo aplicado
    flag = true;
end

if flag % if apenas para verificar a evolução do algoritmo
    disp("Índice de atendimentos válidos: " + newSol.indiceAtendimento*100 + "%");
    disp("Quantidade de PA's utilizados: " + newSol.qtde);
    disp("Distância média: " + newSol.distanciaMedia);
    disp("Avaliação: " + newSol.avaliacao);
    disp("Horário: " + datestr(now, 'HH:MM'));
    fprintf('\n')
end

end
