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


function f = fobj2(x)

f1 = x(1);
f2 = x(2);

g(1) = -x(1);
g(2) = -x(2);
g(3) = -x(1)^4 - x(2) + 1;

f1 = f1 + 10 * sum( max(0,g).^2 );
f2 = f2 + 10 * sum( max(0,g).^2 );

f = [f1 f2]';

