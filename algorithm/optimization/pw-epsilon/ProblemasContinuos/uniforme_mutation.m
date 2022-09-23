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
%   Realiza mutação uniforme
% =========================================================================


function y = uniforme_mutation(x,ub,lb,sigma,xlimites,n)

D = 2*rand(n,1) - 1;
delta = sigma*(ub - lb).*D;
y = x + delta;
y = boxConstraints(y, xlimites);

