clc; 
clear; 
close all
%% Gerando sinal PRBS 
u=getPRBS(400,8,2);
figure(1);
plot(u,'r');
ylim([-0.5,1.5]);
xlim([0,400]);
grid on;
legend("Sinal PRBS");
xlabel('Tempo');
ylabel('Sinal');
%% Função de Transferência: K.e^(-o.s) / tal.s + 1
K = 3.4;
theta = 10;
tal = 9;
t = 400;
T = 1:t;
%% a) Escolha de parâmetros para a FT e simule a resposta ao PRBS de 300 amostras
G1 = tf(K, [tal 1],'InputDelay',theta);
y = lsim(G1, u, T);
figure(2);
plot(y,'r');
xlim([0,400]);
grid on;
legend("Saída da FT ao PRBS");
xlabel('Tempo');
ylabel('Sinal');
%% b) Estime o atraso puro de tempo por meio da FCC
figure(3)
[tuy,ruy,luy,Buy] = myccf([y u'], 400, 1, 0);
plot(tuy, ruy, 'k', 'linewidth', 1.25)
hold on
plot(tuy, luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
hold on
plot(tuy, -luy*ones(length(tuy)), ':k', 'markersize', 0.5) 
ylim([-0.4, 0.8])
title('Correlação Entrada-Saída');
xlabel('Atraso(ms)');
hold off
%% c) Use MQ para estimar os demais parâmetros da FT
% condições iniciais
Ts=1;
P=eye(2)*10^6;
ini=10;
% estimativa de constante de tempo inicial
% estimativa de ganho inicial
% a1 = 1-Ts/tal => a1= 1-(1/9) ~ 0.88
% b1 = Ts.K/Ts => 1*2/1 = 2
%
teta(:,ini-1)=[1-(1/9);1*2/1];
y = y(ini:400);
u = u(1:400-ini);
y = y - mean(y);
u = u - mean(u);
% fator de esquecimento
lambda=0.998;
% Algoritmo recursivo
for k=ini:length(y)
   psi_k=[y(k-1);u(k-1)];
   K_k = (P*psi_k)/(psi_k'*P*psi_k+lambda);
   teta(:,k)=teta(:,k-1)+K_k*(y(k)-psi_k'*teta(:,k-1));
   P=(P-(P*psi_k*psi_k'*P)/(psi_k'*P*psi_k+lambda))/lambda;
end
[a b]=size(teta);
% constante de tempo e ganho
for k=1:b   
   tau(k)=-Ts/(teta(1,k)-1);
   ganho(k)=tau(k)*teta(2,k)/Ts;
end
figure(4)
subplot(211);
plot(Ts:Ts:(b-2*ini+2)*Ts,tau(ini-1:b-ini),'k-');
ylabel('constante de tempo (s)');
title('(a)');
subplot(212)
plot(Ts:Ts:(b-2*ini+2)*Ts,ganho(ini-1:b-ini),'k-');
ylabel('ganho');
xlabel('tempo (s)');
title('(b)');