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
function sol = VNS(fobj, sol)

kmax = 3;
nfe = 0; 

sol = feval(fobj, sol);
nfe = nfe + 1;

while (nfe < 5000)
    
    k = 1;
    while (k <= kmax)
        nfe = nfe + 1;
        y.var = shake(sol.var, k);
        y = feval(fobj, y);
        [sol, k] = neighborhoodChange(sol, y, k);   
    end
end
