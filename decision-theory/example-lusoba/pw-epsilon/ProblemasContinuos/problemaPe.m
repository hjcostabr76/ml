%
% Problema Pe
%

function fitness = problemaPe(fobj,x,e)

f = feval(fobj,x);
f = f(:);
e = e(:);

jfobj  = 1;             % índice da função objetivo a ser minimizada
jconst = 1:length(f);
jconst(jfobj) = [];

fitness = f(jfobj) + 1000 * sum( max(0,f(jconst)-e(jconst)).^2 );




