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


function f = fobj3(x)

f1 = x(1)^2 + x(2)^2;
f2 = (x(1)-1)^2 + (x(2)-0.5)^2;
f3 = (x(1)-0.5)^2 + (x(2)-1)^2;

f = [f1 f2 f3]';


