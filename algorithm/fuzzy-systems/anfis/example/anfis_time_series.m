%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Universidade Federal de Minas Gerais - UFMG
%% Engenharia de Sistemas - 2021/1
%% Clara Amorim Bacha de Almeida - 2017001575
%% Gustavo Henrique Ribeiro de Deus - 2016026329 
%% 
%% Previsão de uma série temporal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all;
close all;
clc

%carregamento basico
t = [19:1:995];
load mg.mat

%entradas do modelo
ys = x(t + 6);
x1 = x(t - 18);
x2 = x(t - 12);
x3 = x(t - 6);
x4 = x(t);

%configuracao das iterações e teste
tam=length(t);
tam_trein=0.8*tam;
tam_test=0.2*tam;
X_treino = [x1(1:tam_trein) x2(1:tam_trein) x3(1:tam_trein) x4(1:tam_trein)];
Yd_treino = ys(1:tam_trein);
X_teste = [x1(tam_trein+1:end) x2(tam_trein+1:end) x3(tam_trein+1:end) x4(tam_trein+1:end)];
Yd_teste = ys(tam_trein+1:end);

%Configuração ANFIS
N_fpertinencia = 2;
Tipo_fpertinencia = char('gbellmf');
geracoes = 200;

%treinamento anfis
input = genfis1([X_treino(:,1) X_treino(:,2) X_treino(:,3) X_treino(:,4) Yd_treino],N_fpertinencia, Tipo_fpertinencia, 'linear');
output = anfis([X_treino(:,1) X_treino(:,2) X_treino(:,3) X_treino(:,4) Yd_treino], input, geracoes);

%criação dos parametros p avaliação
Ys = evalfis([x1 x2 x3 x4],output);
Ys_treino = evalfis(X_treino,output);
erro_verif_trein = 1/2*sumsqr(Ys_treino - Yd_treino);%immse(Yd_treino,Ys_treino);

    %também é necessário comparar os dados do teste
Ys_teste = evalfis(X_teste,output);
erro_verif_test = 1/2*sumsqr(Ys_teste - Yd_teste);%immse(Yd_treino,Ys_treino);

%comparação do teste
figure(1)
plot([1:tam_trein],Yd_treino, 'b-')
hold on
% plot(t,Yd_treino,'ro')
% plot(t,Yd_teste,'go')
plot([1:tam_trein],Ys_treino,'c--')
title(strcat('MSE: ',string(erro_verif_trein)),'FontSize',10);
legend('Valores Reais','ANFIS Aproximação');

%comparação do teste
figure(2)
plot([1:tam_test],Yd_teste, 'b-')
hold on
% plot(t,Yd_treino,'ro')
% plot(t,Yd_teste,'go')
plot([1:tam_test],Ys_teste,'c--')
title(strcat('MSE:  ',string(erro_verif_test)),'FontSize',10);
legend('Valores Reais','ANFIS Aproximação');
