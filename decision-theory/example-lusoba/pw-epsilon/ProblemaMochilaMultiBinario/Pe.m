%
% Estrat?gia eps-Restrito Pe
%

clear all
close all
clc


% carrega dados do problema
load pmm.mat

% função objetivo vetorial do problema
fobj = @fpmm; 


% Determina a soluão utópica (aproximada) usando Pw
I = eye(pmm.m);
for k = 1:pmm.m
    sol.var = round(rand(1,pmm.n));    
    w = I(:,k);
    
    X{k} = VNS(@(x) problemaPw(fobj,x,w,pmm), sol);    
    f(:,k) = X{k}.retorno';
end
eps = [ min(f,[],2) max(f,[],2) ];


sol.var = round(rand(1,pmm.n)); % gera solução inicial

N = 100;    % número de soluções Pareto-ótimas ESTIMADAS
for i = 1:N
    
    e = (eps(:,2)-eps(:,1)).*rand(pmm.m,1) + eps(:,1);
    
    X{i} = VNS(@(x) problemaPe(fobj,x,e,pmm), sol);
        
    sol = X{i};    
end


% Plota espaço de objetivos se m = 2 ou m = 3
f = inf(pmm.m,N);
v = ones(1,N);      % identifica soluções viáveis
for i = 1:N    
    f(:,i) = X{i}.retorno';
    if X{i}.g > 0, v(i) = 0; end        
end

t = v==1;
if pmm.m == 2
    plt1 = plot(f(1,:),f(2,:),'ro');
    hold on
    plt2 = plot(f(1,t),f(2,t),'bo');
    xlabel('f1'), ylabel('f2')
    legend([plt1, plt2], 'Sol. Inviáveis', 'Sol. Factíveis')
    hold off
elseif pmm.m == 3
    plt1 = plot3(f(1,:),f(2,:),f(3,:), 'ro');
    hold on
    plt2 = plot3(f(1,t),f(2,t),f(3,t), 'bo');    
    xlabel('f1'), ylabel('f2'), zlabel('f3')
    legend([plt1, plt2], 'Sol. Inviáveis', 'Sol. Factíveis')
    box on
    hold off    
end

