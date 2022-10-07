clc; clear all; close all; 

% H(z) = b1.z^-1 + b2.z^-2 / 1 + a1.z^-1 + a2.z^-2
% H(z) = b1.z^1 + b2 / z^2 + a1.z^1 + a2
% a1,b1,a2,b2 devem resultar em um sistema assintoticamente estavel

%% a) Projeto de teste
% a1 = 2*zeta*Wn
% a2 = Wn^2
% modulo dos zeros < 1
a1 = 2*0.5*0.8; 
a2 = 0.8^2; 
b1 = 1; 
b2 = 0.7; 
ts = 0.05; 
z = tf('z',ts); 
H = (b1 * z^1 + b2) / (z^2 + a1 * z^1 + a2)
% pole(sys)
% zero(sys)

% Gerando sinal PRBS 
u = prbs(2000,10,3); 

% Função de Transferência: z + 0.7 / z^2 + 0.8z + 0.64
t = ts:ts:100; 

% Simulação da função
y = lsim(H, u, t); 

figure(); 
hold on; 
plot(t, u, 'r'); xlabel('t(s)'); ylabel('y(t)'); 
plot(t, y, '-ob'); xlabel('t(s)'); ylabel('y(t)'); 
title('Resposta ao Impulso'); 
legend('Input', 'Output'); 
hold off; 

figure(1); 
subplot(211); 
plot(u(1:100)); 
grid on; 
title("Entrada PRBS"); 
xlabel('Tempo'); 
ylabel('Sinal'); 

subplot(2,1,2); 
plot(y(1:100)); 
title("Saída da FT"); 
grid on; 
xlabel('Tempo'); 
ylabel('Sinal'); 

% saveas(gcf,"PRBS.png"); 
% close 

% Gerando Ym
y_m = zeros([length(y), 1]); 
e = randn(length(y),1); 
for k = 3:length(y)
    y_m(k) = -a1*y_m(k-1) -a2*y_m(k-2) + b1*u(k-1) + b2*u(k-2)+ e(k); 
end

figure(2)
subplot(211); 
plot(y(1:100)); 
grid on; 
title("Saída"); 

subplot(2,1,2); 
plot(y_m(1:100)); 
title("Saída com ruído"); 
grid on; 
xlabel('Tempo'); 
ylabel('Sinal'); 

saveas(gcf,"Ruido.png"); 
close





















%% b) Estimação dos parâmetros e c) Validação

% Separação de dados de teste e identificação, remoção de média dos sinais
u = u - mean(u); 
y = y - mean(y); 
y_m = y_m - mean(y_m); 

ui = u(1:500); 
yi = y(1:500);

yi_m = y_m(1:500); 
ti = t(1:500); 

uTest = u(501:end);
yTest = y(501:end);
ymTest = y_m(501:end);
tTest = t(501:end);

% Utilizando o estimador de mínimos quadrados  para achar os valores do modelo ARX 

% Condições iniciais:
Ts = ts; % tempo de amostragem dos dados
psi = eye(4)*10^6; 
ini = 3; 
theta(:,ini-1) = [1; 1; 1; 1]; 
lambda = 0.998; % fator de esquecimento

% i) Algoritmo recursivo para o sinal sem ruído
for k = ini:length(yi)
   psi_k = [yi(k-1); yi(k-2); ui(k-1); ui(k-2)]; 
   K_k = (psi*psi_k)/(psi_k'*psi*psi_k+lambda); 
   theta(:,k) = theta(:,k-1)+K_k*(yi(k)-psi_k'*theta(:,k-1)); 
   psi = (psi-(psi*psi_k*psi_k'*psi)/(psi_k'*psi*psi_k+lambda))/lambda; 
end

[a, b] = size(theta); 
params = theta(:,end)




% Validação
HHat = (params(3) * z^1 + params(4)) / (z^2 - params(1) * z^1 - params(2))
yHat = lsim(HHat, uTest, tTest); 

figure(3)
subplot(211); 
plot(yHat,'LineWidth', 2); 
hold on

plot(yTest,'LineWidth', 2); 
title('Validação da saída para o sinal sem ruido', 'FontSize', 15); 
grid on; 

subplot(2,1,2); 
plot(yTest-yHat,'LineWidth', 2); 
title('Erro da saída para o sinal sem ruido', 'FontSize', 15); 
grid on; 

saveas(gcf,"Validacao.png"); 
hold off; 
close



% ii) Algoritmo recursivo para o sinal com ruído
psi = eye(4)*10^6; 
thetaNoise(:,ini-1) = [1; 1; 1; 1]; 
for k = ini:length(yi_m)
   psi_k = [yi_m(k-1); yi_m(k-2); ui(k-1); ui(k-2)]; 
   K_k = (psi*psi_k)/(psi_k'*psi*psi_k+lambda); 
   thetaNoise(:,k) = thetaNoise(:,k-1)+K_k*(yi_m(k)-psi_k'*thetaNoise(:,k-1)); 
   psi = (psi-(psi*psi_k*psi_k'*psi)/(psi_k'*psi*psi_k+lambda))/lambda; 
end
[am, bm] = size(thetaNoise); 
paramsNoise = thetaNoise(:, end)

% Validação
HmHat = (params(3) * z^1 + params(4)) / (z^2 - params(1) * z^1 - params(2))
ymHat = lsim(HmHat, uTest, tTest); 
figure(4)
subplot(211); 
plot(ymHat,'LineWidth', 2); 
hold on
plot(ymTest,'LineWidth', 2); 
title('Validação da saída para o sinal com ruido', 'FontSize', 15); 
grid on; 
subplot(2,1,2); 
plot(ymTest-ymHat,'LineWidth', 2); 
title('Erro da saída para o sinal com ruido', 'FontSize', 15); 
grid on; 
saveas(gcf,"Validacao_erro.png"); 
hold off; 
close






% respostas ao degrau
degrau = zeros([length(tTest), 1]); 
degrau(500:end) = 1; 

yd_real = lsim(H, degrau, tTest); 
yd_estimado = lsim(HHat, degrau, tTest); 
ymd_estimado = lsim(HmHat, degrau, tTest); 

figure(5)
plot(tTest(480:520)', yd_real(480:520), 'k-', 'LineWidth', 2); 
hold on
plot(tTest(480:520)', yd_estimado(480:520), 'g.-.', 'LineWidth', 2); 
plot(tTest(480:520)', ymd_estimado(480:520), 'b:', 'LineWidth', 2); 

title('Respostas ao Degrau Unitário', 'FontSize', 15); 
legend('Resposta do Sistema', 'Resposta do Sistema estimada', 'Resposta do Sistema Estimada com Ruido'); 
grid on; 

saveas(gcf,"degrau.png"); 
hold off; 
close





%% e1) Estimação dos parâmetros e Validação para primeira ordem
% Separação de dados de teste e identificação, remoção de média dos sinais
clear theta thetaNoise yHat ymHat
% Utilizando o estimador de mínimos quadrados  para achar os valores do modelo ARX 
% Condições iniciais:
Ts = ts; % tempo de amostragem dos dados
psi = eye(2)*10^6; 
ini = 3; 
theta(:,ini-1) = [1; 1]; 
% fator de esquecimento
lambda = 0.998; 
% i) Algoritmo recursivo para o sinal sem ruído
for k = ini:length(yi)
   psi_k = [yi(k-1); ui(k-1)]; 
   K_k = (psi*psi_k)/(psi_k'*psi*psi_k+lambda); 
   theta(:,k) = theta(:,k-1)+K_k*(yi(k)-psi_k'*theta(:,k-1)); 
   psi = (psi-(psi*psi_k*psi_k'*psi)/(psi_k'*psi*psi_k+lambda))/lambda; 
end
[a, b] = size(theta); 
params = theta(:,end); 
% Validação
HHat = (params(2)) / (z^1 - params(1))
yHat = lsim(HHat, uTest, tTest); 
figure(6)
subplot(211); 
plot(yHat,'LineWidth', 2); 
hold on
plot(yTest,'LineWidth', 2); 
title('Validação da saída para o sinal sem ruido', 'FontSize', 15); 
grid on; 
subplot(2,1,2); 
plot(yTest-yHat,'LineWidth', 2); 
title('Erro da saída para o sinal sem ruido', 'FontSize', 15); 
grid on; 
saveas(gcf,"Validacao_ord1.png"); 
hold off; 
close
% ii) Algoritmo recursivo para o sinal com ruído
psi = eye(2)*10^6; 
thetaNoise(:,ini-1) = [1; 1]; 
for k = ini:length(yi_m)
   psi_k = [yi_m(k-1); ui(k-1)]; 
   K_k = (psi*psi_k)/(psi_k'*psi*psi_k+lambda); 
   thetaNoise(:,k) = thetaNoise(:,k-1)+K_k*(yi_m(k)-psi_k'*thetaNoise(:,k-1)); 
   psi = (psi-(psi*psi_k*psi_k'*psi)/(psi_k'*psi*psi_k+lambda))/lambda; 
end
[am, bm] = size(thetaNoise); 
paramsNoise = thetaNoise(:,end); 
% Validação
HmHat = (params(2)) / (z^1 - params(1))
ymHat = lsim(HmHat, uTest, tTest); 
figure(7)
subplot(211); 
plot(ymHat,'LineWidth', 2); 
hold on
plot(ymTest,'LineWidth', 2); 
title('Validação da saída para o sinal com ruido', 'FontSize', 15); 
grid on; 
subplot(2,1,2); 
plot(ymTest-ymHat,'LineWidth', 2); 
title('Erro da saída para o sinal com ruido', 'FontSize', 15); 
grid on; 
saveas(gcf,"Validacao_erro_ord1.png"); 
hold off; 
close

% respostas ao degrau
degrau = zeros([length(tTest), 1]); 
degrau(500:end) = 1; 
yd_real = lsim(H, degrau, tTest); 
yd_estimado = lsim(HHat, degrau, tTest); 
ymd_estimado = lsim(HmHat, degrau, tTest); 
figure(8)
plot(tTest(480:520)', yd_real(480:520), 'k-', 'LineWidth', 2); 
hold on
plot(tTest(480:520)', yd_estimado(480:520), 'g.-.', 'LineWidth', 2); 
plot(tTest(480:520)', ymd_estimado(480:520), 'b:', 'LineWidth', 2); 
title('Respostas ao Degrau Unitário', 'FontSize', 15); 
legend('Resposta do Sistema', 'Resposta do Sistema estimada', 'Resposta do Sistema Estimada com Ruido'); 
grid on; 
saveas(gcf,"degrau_ord1.png"); 
hold off; 
close


%% e2) Estimação dos parâmetros e Validação para terceira ordem
% Separação de dados de teste e identificação, remoção de média dos sinais
clear theta thetaNoise yHat ymHat
% Utilizando o estimador de mínimos quadrados  para achar os valores do modelo ARX 
% Condições iniciais:
Ts = ts; % tempo de amostragem dos dados
psi = eye(6)*10^6; 
ini = 4; 
theta(:,ini-1) = [1; 1; 1; 1; 1; 1]; 
% fator de esquecimento
lambda = 0.998; 
% i) Algoritmo recursivo para o sinal sem ruído
for k = ini:length(yi)
   psi_k = [yi(k-1); yi(k-2); yi(k-3); ui(k-1); ui(k-2); ui(k-3)]; 
   K_k = (psi*psi_k)/(psi_k'*psi*psi_k+lambda); 
   theta(:,k) = theta(:,k-1)+K_k*(yi(k)-psi_k'*theta(:,k-1)); 
   psi = (psi-(psi*psi_k*psi_k'*psi)/(psi_k'*psi*psi_k+lambda))/lambda; 
end
[a, b] = size(theta); 
params = theta(:,end)
% Validação
HHat = (params(4) * z^2 + params(5) * z^1 + params(6)) / (z^3 - params(1) * z^2 - params(2) * z^1 - params(3))
yHat = lsim(HHat, uTest, tTest); 
figure(9)
subplot(211); 
plot(yHat,'LineWidth', 2); 
hold on
plot(yTest,'LineWidth', 2); 
title('Validação da saída para o sinal sem ruido', 'FontSize', 15); 
grid on; 
subplot(2,1,2); 
plot(yTest-yHat,'LineWidth', 2); 
title('Erro da saída para o sinal sem ruido', 'FontSize', 15); 
grid on; 
saveas(gcf,"Validacao_ord2.png"); 
hold off; 
close
% ii) Algoritmo recursivo para o sinal com ruído
psi = eye(6)*10^6; 
thetaNoise(:,ini-1) = [1; 1; 1; 1; 1; 1]; 
for k = ini:length(yi_m)
   psi_k = [yi(k-1); yi(k-2); yi(k-3); ui(k-1); ui(k-2); ui(k-3)]; 
   K_k = (psi*psi_k)/(psi_k'*psi*psi_k+lambda); 
   thetaNoise(:,k) = thetaNoise(:,k-1)+K_k*(yi_m(k)-psi_k'*thetaNoise(:,k-1)); 
   psi = (psi-(psi*psi_k*psi_k'*psi)/(psi_k'*psi*psi_k+lambda))/lambda; 
end
[am, bm] = size(thetaNoise); 
paramsNoise = thetaNoise(:,end)
% Validação
HmHat = (params(4) * z^2 + params(5) * z^1 + params(6)) / (z^3 - params(1) * z^2 - params(2) * z^1 - params(3))
ymHat = lsim(HmHat, uTest, tTest); 
figure(10)
subplot(211); 
plot(ymHat,'LineWidth', 2); 
hold on
plot(ymTest,'LineWidth', 2); 
title('Validação da saída para o sinal com ruido', 'FontSize', 15); 
grid on; 
subplot(2,1,2); 
plot(ymTest-ymHat,'LineWidth', 2); 
title('Erro da saída para o sinal com ruido', 'FontSize', 15); 
grid on; 
saveas(gcf,"Validacao_erro_ord2.png"); 
hold off; 
close
% respostas ao degrau
degrau = zeros([length(tTest), 1]); 
degrau(500:end) = 1; 
yd_real = lsim(H, degrau, tTest); 
yd_estimado = lsim(HHat, degrau, tTest); 
ymd_estimado = lsim(HmHat, degrau, tTest); 
figure(11)
plot(tTest(480:520)', yd_real(480:520), 'k-', 'LineWidth', 2); 
hold on
plot(tTest(480:520)', yd_estimado(480:520), 'g.-.', 'LineWidth', 2); 
plot(tTest(480:520)', ymd_estimado(480:520), 'b:', 'LineWidth', 2); 
title('Respostas ao Degrau Unitário', 'FontSize', 15); 
legend('Resposta do Sistema', 'Resposta do Sistema estimada', 'Resposta do Sistema Estimada com Ruido'); 
grid on; 
saveas(gcf,"degrau_ord2.png"); 
hold off; 
close
