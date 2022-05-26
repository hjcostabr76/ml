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
%   Define a fun��o objetivo.
% =========================================================================


function f = fobj(x,custo,n)

% Problema de Designa��o Simples:
% Considere que existem n tarefas e n agentes, de tal forma
% que cada tarefa deve ser atribu�da a um agente e cada
% agente s� pode receber uma tarefa. A execu��o da tarefa i
% pelo agente j tem um custo cij. Formule um problema que
% atribua as tarefas de forma a minimizar o custo total de
% execu��o.

f = 0;
for i = 1:n,
    f = f + custo(i, x(i));
end
