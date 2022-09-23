%
% Problema Pw
%

function fitness = problemaPw(fobj,x,w)

f = feval(fobj,x);

fitness = w(:)'*f(:);
