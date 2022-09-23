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
%   Gera uma nova solução na k-ésima vizinhança de x.
% =========================================================================


function y = shake(x,k,ub,lb,xlimites)

n = length(x);
if k == 1           % polynomial mutation
    y = polynomial_mutation(x,ub,lb,xlimites,n);
elseif k == 2       % uniform mutation with sigma = 0.1
    sigma = 0.1;
    y = uniforme_mutation(x,ub,lb,sigma,xlimites,n);
elseif k == 3       % uniform mutation with sigma = 0.2
    sigma = 0.2;
    y = uniforme_mutation(x,ub,lb,sigma,xlimites,n);
elseif k == 4       % uniform mutation with sigma = 0.3
    sigma = 0.3;
    y = uniforme_mutation(x,ub,lb,sigma,xlimites,n);
end        

