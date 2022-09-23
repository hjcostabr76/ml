function naoDominadas = Pe()

sol = initialSol(); % gera solu��o inicial

clients = csvread('clientes.csv'); % dados do problema

I = eye(2); % matriz indetidade 2x2
for k = 1:2 % atribui os pesos 1 e 0 e depois inverte na proxima execu��o do for
    sol.pesos = I(:,k);     
    X{k} = VNSw(sol, clients); % gera uma solu��o otima com base nos pesos atribuidos
    f(1,k) = X{k}.qtde; 
    f(2,k) = X{k}.distanciaMedia; 
end
eps = [ min(f,[],2) max(f,[],2) ]; % constr�i o epsilon a partir das duas solu��es �timas anteriores


sol = initialSol();

N = 20;    % n�mero de solu��es Pareto-�timas ESTIMADAS
restart = N/2; % iterador pra reiniciar e se desvencilhar de possiveis gargalos
for i = 1:N
    
    if i == restart
        sol = initialSol();
    end
    
    e = (eps(:,2)-eps(:,1)).*rand(2,1) + eps(:,1); % varia��o do epsilon para a proxima restri��o
    
    % queremos minimizar f1, logo vamos colocar f2 como restri��o
    sol.restricao = e(2);
    sol.pesos(1) = (1-0.6).*rand(1) + 0.6; % peso aleatorio mas sempre maior para f1, que queremos minimizar
    sol.pesos(2) = 1 - sol.pesos(1);
    sol.eps = true;
    X{i} = VNSw(sol, clients); % obtem uma solu��o com as novas restri��es e pesos impostos e armazena em x
    
    sol = X{i};
end


naoDominadas = inf(2,N); % matriz para armazenar as solu��es nao dominads

for i = 1:N % for para iterar e verificar as solu��es nao dominadas
    dominada = false;
    for j = 1:N
        if i~=j && X{i}.qtde > X{j}.qtde && X{i}.distanciaMedia > X{j}.distanciaMedia % avalia se � dominada
            dominada = true;
            break;
        end
    end
    if ~dominada % se nao for dominada insere na matriz
        naoDominadas(1,i) = X{i}.qtde;
        naoDominadas(2,i) = X{i}.distanciaMedia;
    end
end