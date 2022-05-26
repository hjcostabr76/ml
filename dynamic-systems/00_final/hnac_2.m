clc; clear all; close all;

ds  = load('dados_tarefa5.txt');
tDs  = ds(:, 1);
uDs  = ds(:, 2);
yDs = ds(:, 3);

% Plot dos dados de entrada e saída, sem divisão
figure(1);
subplot(2, 1, 1);
plot(tDs, uDs, 'r-');
title('Entrada', 'FontSize', 15);

subplot(2, 1, 2);
plot(tDs, yDs, 'LineWidth', 2);
grid on;
title('Saída', 'FontSize', 15);

saveas(gcf, 'Dados.png');


%% a) Pré processamento

% i) Divisão dos dados em identificação e validação
tTest = tDs(1:1000);
uTest = uDs(1:1000);
yTest = yDs(1:1000);

tId = tDs(1001:end);
uId = uDs(1001:end);
yId = yDs(1001:end);

figure(2);
subplot(2, 1, 1);
plot(tTest, uTest, 'r-');
title('Entrada para Validação', 'FontSize', 15);

subplot(2, 1, 2);
plot(tTest, yTest, 'LineWidth', 2);
grid on;
title('Saída para Validação', 'FontSize', 15);

saveas(gcf, 'Dados_Validacao.png');

figure(3);
subplot(2, 1, 1);
plot(tId, uId, 'r-');
title('Entrada para Identificação', 'FontSize', 15);

subplot(2, 1, 2);
plot(tId, yId, 'LineWidth', 2);
grid on;
title('Saída para Identificação', 'FontSize', 15);

saveas(gcf, 'Dados_Identificacao.png');



% ii) Escolha do tDs de amostragem
figure(4)
[tuy, ruy, luy, Buy] = myccf([yId yId], 300, 0, 0);
plot(tuy, ruy, 'k', 'linewidth', 1.25)
hold on
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
hold on
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5) 

title('Autocorrelação da Saída');
xlabel('Atraso(amostras)');
hold off
saveas(gcf, 'Funcao_autocorrelacao.png');

% Cálculo do período do sinal
Tn = (258*0.05) / 4
% Período máximo de amostragem
Tn / 5
% Período mínimo de amostragem
Tn / 10

% O fator de decimação é 10:
tId = tId(1:10:end);
uId = uId(1:10:end);
yId = yId(1:10:end);
tTest = tTest(1:10:end);
uTest = uTest(1:10:end);
yTest = yTest(1:10:end);

figure(5);
subplot(2, 1, 1);
plot(tIdDec, uIdDec, 'r-');
title('Entrada para Identificação Decimada', 'FontSize', 15);

subplot(2, 1, 2);
plot(tIdDec, yIdDec, 'LineWidth', 2);
grid on;
title('Saída para Identificação Decimada', 'FontSize', 15);

saveas(gcf, 'Dados_Decimados.png');


% iii) Utlização da função de correlação cruzada para identificação do modelo
figure(6)
[tuy, ruy, luy, Buy] = myccf([yIdDec uIdDec], 100, 1, 0);
plot(tuy, ruy, 'k', 'linewidth', 1.25)
hold on
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
hold on
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
title('Correlação Cruzada da Saída com Entrada');
xlabel('Atraso(amostras)');
hold off

saveas(gcf, 'Funcao_correlacao_cruzada.png');

% Remoção do atraso puro de tDs e média dos sinais
uIdDec = uIdDec(5:end);
yIdDec = yIdDec(1:end-4);
tIdDec = tIdDec(1:end-4);

uIdDec = uIdDec - mean(uIdDec);
yIdDec = yIdDec - mean(yIdDec);

figure(7);
subplot(2, 1, 1);
plot(tIdDec, uIdDec, 'r-');
title('Entrada Preparada', 'FontSize', 15);

subplot(2, 1, 2);
plot(tIdDec, yIdDec, 'LineWidth', 2);
grid on;
title('Saída Preparada', 'FontSize', 15);

saveas(gcf, 'Dados_Preparados.png');





%% b) Selção de Estrutura

% Método Akaike para selecionar a ordem do modelo ARX
N = 15;
Y = yIdDec(N:end);
aic = zeros([1, N-1]);
bic = zeros([1, N-1]);
psi = [];
for k = 1:(N-1)
    psi = [psi yIdDec(N-k:end-k)];
    theta = pinv(psi)*Y;
    xi = Y-psi*theta;
    aic(k) = AIC(xi, k);
    bic(k) = BIC(xi, k);
end

figure(8)
subplot(2, 1, 1);
plot(aic, 'LineWidth', 2);
xlabel('Ordem do Modelo');
title('Critério de Akaike', 'FontSize', 15);
grid on;

subplot(2, 1, 2);
plot(bic, 'LineWidth', 2);
xlabel('Ordem do Modelo');
title('Critério de Bayes', 'FontSize', 15);
grid on;

saveas(gcf, 'Akaike.png');
close all;




%% c) Estimação de parâmetros

% Utilizando o estimador de mínimos quadrados  para achar os valores do modelo ARX 

% Condições iniciais:
Ts=0.5; % tDs de amostragem dos dados
P=eye(10)*10^6;
ini=6; 
theta(:, ini-1)=[1;1;1;1;1;1;1;1;1;1];

% fator de esquecimento
lambda=0.998;

% Algoritmo recursivo
for k=ini:length(yIdDec)
   psi_k=[yIdDec(k-1);yIdDec(k-2);yIdDec(k-3);yIdDec(k-4);yIdDec(k-5);uIdDec(k-1);uIdDec(k-2);uIdDec(k-3);uIdDec(k-4);uIdDec(k-5)];
   K_k = (P*psi_k)/(psi_k'*P*psi_k+lambda);
   theta(:, k)=theta(:, k-1)+K_k*(yIdDec(k)-psi_k'*theta(:, k-1));
   P=(P-(P*psi_k*psi_k'*P)/(psi_k'*P*psi_k+lambda))/lambda;
end

[a b]=size(theta);
params = theta(:, end);

%% d) Validação
uTestDec = uTestDec(5:end);
yTestDec = yTestDec(1:end-4);
tTestDec = tTestDec(1:end-4);
uTestDec = uTestDec - mean(uTestDec);
yTestDec = yTestDec - mean(yTestDec);

% i) Simulação um passo a frente
y_hat = zeros([1, length(yTestDec)]);
for k = ini:length(yTestDec)
    y_hat(k) = dot([yTestDec(k-1), yTestDec(k-2), yTestDec(k-3), yTestDec(k-4), yTestDec(k-5), uTestDec(k-1), uTestDec(k-2), uTestDec(k-3), uTestDec(k-4), uTestDec(k-5)], params);
end

figure(9)
subplot(2, 1, 1);
plot(y_hat', 'LineWidth', 2);
hold on
plot(yTestDec, 'LineWidth', 2);
title('Validação de um passo a frente', 'FontSize', 15);
grid on;
subplot(2, 1, 2);
plot(yTestDec-y_hat', 'LineWidth', 2);
title('Erro da saída', 'FontSize', 15);
grid on;
saveas(gcf, 'Passo_frente.png');
hold off;

% ii) Simulação livre
y_hat2 = zeros([1, length(yTestDec)]);
y_hat2(1:5) = yTestDec(1:5)';
for k = ini:length(yTestDec)
    y_hat2(k) = dot([y_hat2(k-1), y_hat2(k-2), y_hat2(k-3), y_hat2(k-4), y_hat2(k-5), uTestDec(k-1), uTestDec(k-2), uTestDec(k-3), uTestDec(k-4), uTestDec(k-5)], params);
end
figure(10)
subplot(2, 1, 1);
plot(y_hat2, 'LineWidth', 2);
hold on
plot(yTestDec, 'LineWidth', 2);
title('Validação de simulação livre', 'FontSize', 15);
grid on;
subplot(2, 1, 2);
plot(yTestDec-y_hat2', 'LineWidth', 2);
title('Erro da saída', 'FontSize', 15);
grid on;
saveas(gcf, 'Simulacao_livre.png');
hold off;
close all

% iii) Calculo do indice RMSE
erro1 = 0;
erro2 = 0;
for k = 1:length(yTestDec)
   erro1 = erro1 + (yTestDec(k) - y_hat(k)')^2/length(yTestDec);
   erro2 = erro2 + (yTestDec(k) - y_hat2(k)')^2/length(yTestDec);
end
erro1
erro2

% iv) Verificação dos resíduos  dos modelos
res1 = yTestDec-y_hat2'
res2 = yTestDec-y_hat'

figure(11)
[tuy, ruy, luy, Buy] = myccf([res1 res1], 40, 0, 0);
plot(tuy, ruy, 'k', 'linewidth', 1.25)
hold on
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
hold on
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
title('Autocorrelação dos Resíduos');
xlabel('Atraso(amostras)');
hold off

saveas(gcf, 'AutoCorr_residuo_1.png');

figure(12)
[tuy, ruy, luy, Buy] = myccf([res2 res2], 40, 0, 0);
plot(tuy, ruy, 'k', 'linewidth', 1.25)
hold on
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
hold on
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
title('Autocorrelação dos Resíduos');
xlabel('Atraso(amostras)');
hold off

saveas(gcf, 'AutoCorr_residuo_2.png');

figure(13)
[tuy, ruy, luy, Buy] = myccf([uTestDec res1], 40, 1, 0);
plot(tuy, ruy, 'k', 'linewidth', 1.25)
hold on
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
hold on
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
title('Correlação Cruzada Entrada-Resíduos');
xlabel('Atraso(amostras)');
hold off

saveas(gcf, 'Corr_residuo_1.png');

figure(14)
[tuy, ruy, luy, Buy] = myccf([uTestDec res2], 40, 1, 0);
plot(tuy, ruy, 'k', 'linewidth', 1.25)
hold on
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
hold on
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
title('Correlação Cruzada Entrada-Resíduos');
xlabel('Atraso(amostras)');
hold off

saveas(gcf, 'Corr_residuo_2.png');

% AIC = N * ln(sigma(n)^2) + 2n; sigma^2 = var()
function a = AIC(ds, param)
    a = length(ds) * log(var(ds)) + 2*param;
end
function b = BIC(ds, param)
    b = length(ds) * log(var(ds)) + param*log(length(ds));
end