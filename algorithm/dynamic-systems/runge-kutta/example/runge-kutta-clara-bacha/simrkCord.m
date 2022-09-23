% Simulates the Cord system in dvCord.m by performing numerical integration
% using the algorithm implemented in rkCord.m 

% LAA 15/8/18

clear; close all


t0=0; % initial time
tf=100; % final time
% integration interval
h=0.1;
t=t0:h:tf-1; % time vector


% initial conditions
x0=[1.2;0.7];

% initialization
x=[x0 zeros(length(x0),length(t)-1)];
%função testada, erro não ta aqui
% u=sinal(4,20,2000,length(t));
%u(1:tf) = 0

u=zeros(1,length(t));
% u(1, floor(length(t)/5 + 1):length(t))=ones(1, length(t) - floor(length(t)/5));
% u = u*0.3;

% u = sinal(7, 0.03, 100, length(t)) %degraus
% u = sinal(4, 0.05, 300, length(t)) % degrau
% u = sinal(5, 0.05, 300, length(t)) %senoide
%u = sinal(2, 0.5, 400, length(t)) % degraus
u = sinal(2, 0.05, 400, length(t)) % aleatoria


for k=2:length(t)
    x(:,k)=rkCord(x(:,k-1),u(k),u(k),h,t(k));appdesigner
end


% u1= u(1:length(u),1);
x1 = x(1,1:length(x));
x2 = x(2,1:length(x));
tnew = t 

figure(1)
yyaxis right
plot(tnew,x1);
ylabel('Concentração de biomassa X1 - (g/L)')
yyaxis left
plot(tnew,u)
% ylabel('Aumento da vazão - cm³/s')
% set(gca,'FontSize',18)
% xlabel('time')
% ylabel('x_1')
% figure(2)
% yyaxis right
% plot(tnew,x2);
% ylabel('H2 - cm')
% yyaxis left
% plot(tnew,u)
% set(gca,'FontSize',18)
% xlabel('time')
% ylabel('Aumento da vazão - cm³/s')
