%==========================================================================
% Universidade Federal de Minas Gerais
% Escola de Engenharia da UFMG
% Depto. de Engenharia Elétrica
%
% Autor:
%   Lucas S. Batista
%
% Atualização: 27/11/2020
%
% Nota:
%   Atualiza a solução corrente e a estrutura de vizinhança.
% =========================================================================


function [sol,k] = neighborhoodChange(sol,y,k)

if y.fitness > sol.fitness
    sol = y;    
    k   = 1;
else
    k = k + 1;
end
