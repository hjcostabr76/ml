%
%======================================================================
%
% PROVA COMPUTACIONAL
% Aluno: Hebert Costa / Matrícula: 2016 097 439
%
% TAREFA
% Dado a função de transferencia G, estimar parametros K, theta & tau.
% G(s) = K.exp(-theta.s) / (tau.s + 1)
%
%======================================================================
%


clc; clear all; close all;

%% Importar dados
FILE_NAME = 'data_prova_tmsd_13.dat';
ds = load(FILE_NAME);

tDs = ds(:, 1);
uDs = ds(:, 2);
yDs = ds(:, 3);

%
%======================================================================
%
%% Separar dados: Estimacao X Validacao
%
%======================================================================
%

tMaxSim = 100;
tMinValidation = tMaxSim + 1;

tSim = tDs(1:tMaxSim);
uSim = uDs(1:tMaxSim);
ySim = yDs(1:tMaxSim);

tValidation = tDs(tMinValidation:end);
uValidation = uDs(tMinValidation:end);
yValidation = yDs(tMinValidation:end);

%
%======================================================================
%
%% Exibir dados
%
%======================================================================
%

tSize = length(tDs);

% Plot: Entrada
figure(1);
plot(tDs, uDs);
title('Entrada');

xline(6.76, '--r', 'LineWidth', 2); % Destacar regioes com maiores intervalos
xline(8.58, '--r', 'LineWidth', 2);
xline(38.22, '--r', 'LineWidth', 2);
xline(40.82, '--r', 'LineWidth', 2);

% Plot da saída completa
figure(2);
subplot(3, 1, 1);

plot(tDs, yDs);
title('Resposta do sistema (completa)');
grid on;

% Plot da saída (particoes de estimacao)
subplot(3, 1, 2);

yExtended = zeros(1, tSize);
yExtended(1:tMaxSim) = ySim;
plot(tDs, yExtended, 'b-');
title('Resposta do sistema (reservada para estimacao)');
grid on;

% Plot da saída (validacao)
subplot(3, 1, 3);

yExtended = zeros(1, tSize);
yExtended(tMinValidation:end) = yValidation;
plot(tDs, yExtended, 'r-');
title('Resposta do sistema (reservada para validacao)');
grid on;

%
%======================================================================
%
%% Estimar atraso puro de tempo
%
% Ao analisar a FCC (funcao de correlacao cruzada) sabemos que o instante de tempo
% aonde se observa o valor de correlacao mais alto (excedendo os limites do intervalo de confianca)
% marca o atraso puro de tempo theta.
% 
% Verificamos, portanto, no instante t = 1 a ocorrencia procurada.
% Portanto, a partir da inspecao grafica podmos afirmar que theta = 1
% 
%======================================================================
%

fccLength = 50;
[tuy, ruy, luy, Buy] = myccf([yValidation uValidation], fccLength, 1, 0);

figure(3); hold on;
plot(tuy, ruy);
plot(tuy, luy * ones(fccLength + 1), '--r');   % Intervalo de confianca (limite superior)
plot(tuy, -luy * ones(fccLength + 1), '--r');  % Intervalo de confianca (limite inferior)
grid on;

title('Correlacao: Entrada X Saida');
hold off;

%
%======================================================================
%
%% Estimar K (gain) & tau (constante de tempo)
%
% Pela inspecao visual do grafico da entrada (no intevalo separado para estimacao)
% observamos que aproximadamente o maior intervalo de entradas ocorre entre os instantes
% t = 6.7 e t = 8.6. Aproximacao pelo ponto medio desse intervalo, seleciona-se o valor t = 7.7.
% 
% Pegando o valor de saida (entre os dados separados para estimacao) correspondente a esse instante temos:
% - Ganho K ≃ (1.3 - 2) ~= -0.7;
% - tau ≃ (7.5 - 1) ~= -6.5;
% 
% Afim de realizar a estimativa via metodo recursivo utilizamos esses valores estimados para
% determinar os seguintes coeficientes:
% - a1 = 1 - tS / tau;
% - b1 = tS.K / tS;
% 
%======================================================================
%

tS = 0.25; % Intervalo de amostragem (determinado pelos dados da medicao)
psi = eye(2) * 10^6;
t0 = 2;

a1 = 1 - tS / -6.5;
b1 = -.7;
theta(:, t0-1) = [a1 ; b1];

% Remover media + atraso puro de tempo
yValidation = yValidation - mean(yValidation);
uValidation = uValidation - mean(uValidation);

lambda = 0.998; % Fator de esquecimento

% Algoritmo recursivo
for k = t0:length(yValidation)
    aux1 = [yValidation(k - 1); uValidation(k - 1)];
    aux2 = psi*aux1 / (aux1'*psi*aux1 + lambda);
    theta(:, k) = theta(:, k - 1) + aux2*(yValidation(k) - aux1'*theta(:, k - 1));
    psi = (psi - (psi*aux1*aux1'*psi) / (aux1'*psi*aux1 + lambda)) / lambda;
end;

[a b] = size(theta);

% Concluir definicao de tau & K
for k=1:b 
    tau(k) = -tS / (theta(1, k) - 1);
    gain(k) = tau(k) * theta(2, k) / tS;
end;

% Exibir resultado
auxInterval1 = tS:tS:(b - 2*t0 + 2)*tS;
auxInterval2 = t0-1:b-t0;

figure(4)
subplot(211);
plot(auxInterval1, tau(auxInterval2), 'k-');
title('Constante de tempo \tau');

subplot(212)
plot(auxInterval1, gain(auxInterval2), 'k-');
title('Ganho K');

%
%======================================================================
%
%% Validar modelo
% 
%======================================================================
%

K = gain(end);
theta = 0;
tau = tau(end);

G = tf(K, [tau 1], 'InputDelay', theta);
yHat = lsim(G, uSim, tSim);

figure(5); hold on;
plot(yHat, 'b');
plot(ySim, 'r');
grid on;

legend('Aproximacao', 'Real')
title('Validacao final do Modelo');

fprintf("\nResultado:\nK = %f; theta = %f; tau = %f", K, theta, tau);
