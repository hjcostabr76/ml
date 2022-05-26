close all
clc

% gera solução inicial
sol = initialSol();

clients = csvread('clientes.csv');

N = 20;    % número de soluções Pareto-ótimas ESTIMADAS
for i = 1:N
    
    w = rand(2,1);
    w = w/sum(w);
    
    sol.pesos = w;
    
    X{i} = VNSw(sol, clients);
    
    sol = X{i};
end

f = inf(2,N);
for i = 1:N    
    f(1,i) = X{i}.qtde;
    f(2,i) = X{i}.distanciaMedia;
end

plt1 = plot(f(1,:),f(2,:),'ro');
hold on
xlabel('f1'), ylabel('f2')
legend(plt1, 'Soluções')
hold off