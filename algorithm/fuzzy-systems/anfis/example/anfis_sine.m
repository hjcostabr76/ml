%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Universidade Federal de Minas Gerais - UFMG
%% Engenharia de Sistemas - 2021/1
%% Clara Amorim Bacha de Almeida - 2017001575
%% Gustavo Henrique Ribeiro de Deus - 2016026329 
%% 
%% Aproximação do seno por meio de ANFIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all;
close all;
clc

%carregamento basico
XX = 0:0.1:2*pi;
Y = sin(XX); %sistema real

%Dados
N = 100;
X = 0 + (2*pi - 0).*rand(N,1);
Yd = sin(X) + 0.15*randn(length(X),1);

%configuracao das iterações e teste
tam_treino=0.8*N;
X_treino = X(1:tam_treino);
Yd_treino = Yd(1:tam_treino);
X_teste = X(tam_treino+1:end);
Yd_teste = Yd(tam_treino+1:end);

%Configuração ANFIS
N_fpertinencia = 5;
Tipo_fpertinencia = char('gaussmf');
geracoes = 200;

%treinamento anfis
input = genfis1([X_treino Yd_treino],N_fpertinencia,Tipo_fpertinencia);
output = anfis([X_treino Yd_treino], input, geracoes);

%criação dos parametros p avaliação
Ys = evalfis(XX,output);
Ys_treino = evalfis(X_treino,output);
Ys_teste = evalfis(X_teste,output);

erro_verif = 1/2*sumsqr(Ys - Y');%immse(Yd_treino,Ys_treino);
fprintf('real %d', erro_verif);

%comparação do teste
figure(1)
plot(XX,Y, 'b-')
hold on
plot(X_treino,Yd_treino,'ro')
plot(X_teste,Yd_teste,'go')
plot(XX,Ys,'c--')
legend('Valores Reais','Treino','Teste','ANFIS Aproximação');