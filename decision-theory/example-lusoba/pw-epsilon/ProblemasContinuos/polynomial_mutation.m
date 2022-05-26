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
%   Realiza mutação polinomial
% =========================================================================


function P = polynomial_mutation(P,ub,lb,xlimites,n)

ni_m = 5;
pm = 1/n;

[nvar,np] = size(P);
delta = zeros(nvar,1);
h = zeros(nvar,1);
p = zeros(nvar,1);

for i = 1:np
    
    rnd = rand(nvar,1);    
    if ~isempty(rnd(rnd<=pm))        
            
        y = P(:,i);
        delta1 = (y-lb)./(ub-lb);
        delta2 = (ub-y)./(ub-lb);
        
        delta_max = max([delta1 delta2],[],2);
        
        r = rand(nvar,1);
        h(r<=0.5) = 1 - delta_max(r<=0.5);
        h(r>0.5)  = 1 - delta_max(r>0.5);
        
        p(r<=0.5) = 2*r(r<=0.5) + (1-2*r(r<=0.5)).*(h(r<=0.5).^(ni_m+1));
        p(r>0.5)  = 2*(1-r(r>0.5)) + 2*(r(r>0.5)-0.5).*(h(r>0.5).^(ni_m+1));
        
        delta(r<=0.5) = p(r<=0.5).^(1/(ni_m+1)) - 1;
        delta(r>0.5)  = 1 - p(r>0.5).^(1/(ni_m+1));
               
        P(:,i) = P(:,i) + (ub - lb).*delta; 
        P(rnd>pm,i) = y(rnd>pm);
    end
end
P = boxConstraints(P, xlimites);



