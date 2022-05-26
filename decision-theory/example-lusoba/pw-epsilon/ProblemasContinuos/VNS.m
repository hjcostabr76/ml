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
%   Aproxima o ponto de ótimo (minimização) de um problema irrestrito
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


% Número de estruturas de vizinhanças definidas
kmax = 4;

% Contador do número de avaliações de f(.)
nfe = 0; 

% Definição dos vetores limites
lb = xlimites(1:2:end); lb = lb(:);
ub = xlimites(2:2:end); ub = ub(:);

% Avaliação da solução inicial
jx  = feval(fobj, x);
nfe = nfe + 1;


% Critério de parada
while (nfe < 1000)
    
    k = 1;          
    while (k <= kmax)
        
        % Gera uma solução na k-ésima vizinhança de x
        y   = shake(x,k,ub,lb,xlimites);
        jy  = feval(fobj, y);
        nfe = nfe + 1; 
        
        [x,jx,k] = neighborhoodChange(x,jx, y,jy, k);
    end
end

