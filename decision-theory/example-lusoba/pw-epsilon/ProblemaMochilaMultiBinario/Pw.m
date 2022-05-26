clear all
close all
clc

%
%======================================================================
%
% PMM => Problema de Mochilas Multivariado
% Problema: Selecionar portfolio (projetos) que maximiza o retorno dos objetivos sem exceder recursos disponiveis.
% 
% - n: Numero de projetos;
% - m: Numero de objetivos;
% - v: Capital de investimentos;
% - 01 projeto j tem custo cj & retorno rij para 01 objetivo i.
%
%======================================================================
%

%% Define parametros do problema
fobj = @fpmm;
N = 100; % Numero de solucoes Pareto-Otimas ESTIMADAS

pmm.m = 2; % Objetivos
pmm.n = 100; % Projetos

pmm.r = 30 * rand(pmm.m, pmm.n); % Retorno esperado
pmm.c = 10 * rand(1, pmm.n); % Custo
pmm.b = 0.4 * sum(pmm.c); % Caṕital

%% Gera solucoes otimas
sol.var = round(rand(1, pmm.n)); % NOTE: (var -> variacao)

for i = 1:N, 
    w = rand(pmm.m, 1);
    w = w / sum(w);
    X{i} = VNS(@(x) problemaPw(fobj, x, w, pmm), sol);
    sol = X{i};
end


%% Plota espaco de objetivos
f = inf(pmm.m, N);
v = ones(1, N);      % identifica solu��es vi�veis
for i = 1:N    
    f(:, i) = X{i}.retorno';
    if X{i}.g > 0, v(i) = 0; end
end

t = v==1;
plt1 = plot(f(1, :), f(2, :), 'ro');
hold on
plt2 = plot(f(1, t), f(2, t), 'bo');
xlabel('f1'), ylabel('f2')
legend([plt1, plt2], 'Sol. Invi�veis', 'Sol. Fact�veis')
hold off

function x = problemaPw(fobj,x,w,pmm)
    x = feval(fobj, x, pmm);
    x.fitness = w(:)' * x.retpen(:); % NOTE: (retpen -> Retorno penalizado)
end

function sol = fpmm(sol,pmm)

    % - sol.custo
    % - sol.retorno
    % - sol.g: (custo - capital);
    % - sol.var: Variacao da solucao;
    % - sol.retpen: Retorno penalizado (receita - 100*prejuizo^2);
    
    sol.custo = pmm.c * sol.var(:); % Custo (da variacao da solucao)
    sol.g = sol.custo - pmm.b; % Prejuizo? (custo - capital)
    
    for i = 1:pmm.m    
        sol.retorno(i) = pmm.r(i,:) * sol.var(:);
        sol.retpen(i)  = sol.retorno(i) - 100*max(0, sol.g)^2;
    end
end    