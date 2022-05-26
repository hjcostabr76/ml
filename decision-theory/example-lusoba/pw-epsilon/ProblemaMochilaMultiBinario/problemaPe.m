%
% Problema Pe
%

function x = problemaPe(fobj,x,e,pmm)

x = feval(fobj,x,pmm);
e = e(:)';

jfobj  = 1;             % índice da função objetivo a ser otimizada
jconst = 1:pmm.m;
jconst(jfobj) = [];

x.fitness = x.retpen(jfobj) - 100*sum( max(0,e(jconst)-x.retpen(jconst)).^2 );
