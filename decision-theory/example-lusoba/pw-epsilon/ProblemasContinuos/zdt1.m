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
%   Define a função objetivo.
% =========================================================================


function f = zdt1(x)

% m = 2 e n = 30

n = length(x);
f1 = x(1);
su = sum(x)-x(1);    
g  = 1 + 9 * su / (n - 1);
f2 = (1 - sqrt(x(1) / g));

f = [f1 f2]';



