%
% Estrat�gia Soma Ponderada Pw
%

clear all
close all
clc


fobj = @fobj1;  % problema de otimiza��o multiobjetivo
n = 2;          % n�mero de vari�veis de decis�o
m = 2;          % n�mero de objetivos

xLimits = repmat([0 1], 1, n);
lb = xLimits(1:2:end);
ub = xLimits(2:2:end);

x0 = (ub(:) - lb(:)) .* rand(n, 1) + lb(:);  % gera solu��o inicial

for i = 1:100,   % n�mero de solu��es Pareto - �timas ESTIMADAS

    w = rand(m, 1);
    w = w / sum(w);
    
    X(:, i)  = VNS(@(x) problemaPw(fobj, x, w), x0, xLimits);
    jX(:, i) = fobj(X(:, i));
    
    x0 = X(:, i);
end

% Plota espa�o de objetivos se m = 2 ou m = 3
if m == 2    
    plot(jX(1, :), jX(2, :), 'ro')
    xlabel('f1'), ylabel('f2')      
elseif m == 3
    plot3(jX(1, :), jX(2, :), jX(3, :), 'ro')
    xlabel('f1'), ylabel('f2'), zlabel('f3')
    box on
end

% Plota espa�o de decis�o se n = 2 ou n = 3
if n == 2
    figure
    plot(X(1, :), X(2, :), 'ro')
    xlabel('x1'), ylabel('x2')      
elseif n == 3
    figure
    plot3(X(1, :), X(2, :), X(3, :), 'ro')
    xlabel('x1'), ylabel('x2'), zlabel('x3')
    box on
end
