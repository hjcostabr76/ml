%==========================================================================
% Universidade Federal de Minas Gerais
% Escola de Engenharia da UFMG
% Depto. de Engenharia El�trica
%
% Autor:
%   Lucas S. Batista
%
% Atualiza��o: 27/11/2020
%
% Nota:
%   Atualiza a solu��o corrente e a estrutura de vizinhan�a.
% =========================================================================


function [sol,k] = neighborhoodChange(sol,y,k)

if y.fitness > sol.fitness
    sol = y;    
    k   = 1;
else
    k = k + 1;
end
