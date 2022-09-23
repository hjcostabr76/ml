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
%   Aproxima o ponto de �timo (minimiza��o) de um problema irrestrito
%   usando o RVNS.
% =========================================================================


function [x, jx] = VNS(fobj, x, xlimites)

%
% Sintaxe
% [x, jx] = VNS()
%
% Exemplo
% [x, jx] = VNS()
%


% N�mero de estruturas de vizinhan�as definidas
kmax = 4;

% Contador do n�mero de avalia��es de f(.)
nfe = 0; 

% Defini��o dos vetores limites
lb = xlimites(1:2:end); lb = lb(:);
ub = xlimites(2:2:end); ub = ub(:);

% Avalia��o da solu��o inicial
jx  = feval(fobj, x);
nfe = nfe + 1;


% Crit�rio de parada
while (nfe < 1000)
    
    k = 1;          
    while (k <= kmax)
        
        % Gera uma solu��o na k-�sima vizinhan�a de x
        y   = shake(x,k,ub,lb,xlimites);
        jy  = feval(fobj, y);
        nfe = nfe + 1; 
        
        [x,jx,k] = neighborhoodChange(x,jx, y,jy, k);
    end
end

