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


function [x, jx] = VNS()

%
% Sintaxe
% [x, jx] = VNS()
%
% Exemplo
% [x, jx] = VNS()
%


% N�mero de estruturas de vizinhan�as definidas
kmax = 3;

% Contador do n�mero de avalia��es de f(.)
nfe = 0; 

% Gera solu��o inicial
[x,custo,n] = initialSol();
jx = fobj(x,custo,n);
nfe = nfe + 1;

% Armazena a solu��o corrente
memoryfile(1,:) = [x(:)' jx];


% Crit�rio de parada
while (nfe < 5000)
    
    k = 1;          
    while (k <= kmax),
        
        % Gera uma solu��o na k-�sima vizinhan�a de x
        y   = shake(x,k);
        jy  = fobj(y,custo,n);
        nfe = nfe + 1;        
        
        [x,jx,k] = neighborhoodChange(x,jx, y,jy, k);
        
        % Armazena a solu��o corrente
        memoryfile(size(memoryfile,1)+1,:) = [x(:)' jx];
    end
end
fprintf('\n')

figure
plot(0:size(memoryfile,1)-1,memoryfile(:,end),'k-','linewidth',2)
xlabel('N�mero de avalia��es')
ylabel('Valor da fun��o objetivo')


