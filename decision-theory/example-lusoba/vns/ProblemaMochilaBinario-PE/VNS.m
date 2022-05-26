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
%   Aproxima o ponto de �timo de um problema irrestrito
%   usando o RVNS.
% =========================================================================


function [x, xretorno, xcusto, capital] = VNS()

%
% Sintaxe
% [x, xretorno, xcusto, capital] = VNS()
%
% Exemplo
% [x, xretorno, xcusto, capital] = VNS()
%


% N�mero de estruturas de vizinhan�as definidas
kmax = 3;

% Contador do n�mero de avalia��es de f(.)
nfe = 0; 

% Gera solu��o inicial
[x,projetos,capital] = initialSol();
[xretorno,xcusto,gx,xrpen] = fobj(x,projetos,capital);
nfe = nfe + 1;

% Armazena a solu��o corrente
memoryfile(1,:) = [x(:)' xretorno xcusto gx xrpen];


% Crit�rio de parada
while (nfe < 5000)
    
    k = 1;          
    while (k <= kmax)
        
        % Gera uma solu��o na k-�sima vizinhan�a de x
        y = shake(x,k);        
        [yretorno,ycusto,gy,yrpen] = fobj(y,projetos,capital);
        nfe = nfe + 1;        
        
        [x,xretorno,xcusto,gx,xrpen,k] = neighborhoodChange(x,xretorno,xcusto,gx,xrpen, y,yretorno,ycusto,gy,yrpen, k);
        
        % Armazena a solu��o corrente
        memoryfile(size(memoryfile,1)+1,:) = [x(:)' xretorno xcusto gx xrpen];
    end
end
fprintf('\n')

figure, hold on
plt1 = plot(0:size(memoryfile,1)-1,memoryfile(:,end-3),'b-','linewidth',2);
plt2 = plot(0:size(memoryfile,1)-1,memoryfile(:,end-2),'m-','linewidth',2);
plt3 = plot(0:size(memoryfile,1)-1,memoryfile(:,end-1),'r-.','linewidth',2);
hold off
legend([plt1,plt2,plt3],'retorno','custo','g(x)')
xlabel('N�mero de avalia��es')
ylabel('Valores de interesse')
