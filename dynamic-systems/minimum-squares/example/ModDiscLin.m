% Simulacao de modelos lineares discretos
% videos: 
% https://youtu.be/09Dxfp_RsD4
% https://youtu.be/g4kyoxFExQo
%
% livro texto: 
% https://www.editora.ufmg.br/#/pages/obras?palavra=Aguirre

% LAA 2/6/20





% Definicao dos coeficientes dos polinomios 
a1=1.5; a2=-0.7; % coeficientes do polinomio A
b1=1; b2=0.5; % coeficientes do polinomio B
c1=0.8; % coeficientes do polinomio C
d1=0.4; % coeficientes do polinomio D
f1=0.3; f2=-0.6; % coeficientes do polinomio F

% entrada
u=0.5*sign(sin((pi/10)*[1:80]));

set(gca,'FontSize',16)
plot(u,'k-')
axis([0 80 -1 1])

%%

% ruido branco
nu=randn(size(u))*0.5;

% Modelo FIR 
% polinomios usados: B (os demais sao unitarios)
clear y
for k=3:length(u)
    % Eq. 2.42 do livro texto
    y(k)=b1*u(k-1)+b2*u(k-2)+nu(k);
end

set(gca,'FontSize',16)
plot(y,'r-')



%%
% Modelo ARX 
% polinomios usados: A e B (os demais sao unitarios)
clear y
% condicoes iniciais (arbitrarias)
y(1)=0.2; yo(1)=0.2;
y(2)=-0.3; yo(2)=-0.3
for k=3:length(u)
    % Eq. 2.43 do livro texto depois de passar
    % alguns termos para o lado direito 
    y(k)=a1*y(k-1)+a2*y(k-2)+b1*u(k-1)+b2*u(k-2)+nu(k);
    yo(k)=a1*yo(k-1)+a2*yo(k-2)+b1*u(k-1)+b2*u(k-2);
end

set(gca,'FontSize',16)
plot(1:80,y,'r',1:80,yo,'b')
axis([0 80 -10 10])


%%
% Modelo ARX o caso Monte Carlo
% polinomios usados: A e B (os demais sao unitarios)
clear y
y=zeros(20,80);
% condicoes iniciais (arbitrarias)
y(1)=0.2; 
y(2)=-0.3; 
for j=1:20
 % cada simulacao tem sua propria realizacao de ruido
 nu=randn(size(u))*0.5; 
 for k=3:length(u)
    % Eq. 2.43 do livro texto depois de passar
    % alguns termos para o lado direito 
    y(j,k)=a1*y(j,k-1)+a2*y(j,k-2)+b1*u(k-1)+b2*u(k-2)+nu(k);
 end
end


set(gca,'FontSize',16)
plot(1:80,y(2:20,:),'g:',1:80,y(1,:),'r')



%%
% Modelo ARMAX 
% polinomios usados: A, B e C (os demais sao unitarios)
clear y
% condicoes iniciais (arbitrarias)
y(1)=0.2; 
y(2)=-0.3; 
for k=3:length(u)
    % Eq. 2.45 do livro texto depois de passar
    % alguns termos para o lado direito 
    y(k)=a1*y(k-1)+a2*y(k-2)+b1*u(k-1)+b2*u(k-2)+c1*nu(k-1)+nu(k);
end

set(gca,'FontSize',16)
plot(1:80,y,'r')
axis([0 80 -10 10])





%%
% Modelo ARMA o caso Monte Carlo
% polinomios usados: A e C (os demais sao unitarios)
clear y
y=zeros(20,80);
% condicoes iniciais (arbitrarias)
y(1)=0.2; 
y(2)=-0.3; 
for j=1:20
 % cada simulacao tem sua propria realizacao de ruido
 nu=randn(size(u))*0.5; 
 for k=3:length(u)
    % Eq. 2.47 do livro texto depois de passar
    % alguns termos para o lado direito 
    y(j,k)=a1*y(j,k-1)+a2*y(j,k-2)+c1*nu(k-1)+nu(k);
 end
end


set(gca,'FontSize',16)
plot(1:80,y(2:20,:),'g:',1:80,y(1,:),'r')


%%
% Modelo OEM o caso Monte Carlo
% polinomios usados: F e B (os demais sao unitarios)
clear y
y=zeros(20,80);
% condicoes iniciais (arbitrarias)
w(1)=0.2; 
w(2)=-0.3; 
for j=1:20
 % cada simulacao tem sua propria realizacao de ruido
 nu=randn(size(u))*0.5; 
 for k=3:length(u)
    % Eq. 2.50 do livro texto depois de passar
    % alguns termos para o lado direito 
    w(k)=f1*w(k-1)+f2*w(k-2)+b1*u(k-1)+b2*u(k-2);
    y(j,k)=w(k)+nu(k);
 end
end


set(gca,'FontSize',16)
plot(1:80,y(2:20,:),'g:',1:80,y(1,:),'r',1:80,w,'b')

%%
% Modelo Box-Jenkins 
% polinomios usados: F, B, C e D (os demais sao unitarios)
clear y w
% condicoes iniciais (arbitrarias)
w(1)=0.2; 
w(2)=-0.3; 
e=zeros(length(u));
for k=3:length(u)
    % Codificaremos em duas etapas 
    % parcela devida ao processo
    w(k)=f1*w(k-1)+f2*w(k-2)+b1*u(k-1)+b2*u(k-2);
    % parcela devida ao ruido (sabe chegar a isso?)
    e(k)=-d1*e(k-1)+c1*nu(k-1)+nu(k);
    y(k)=w(k)+e(k);
end

set(gca,'FontSize',16)
plot(1:80,y,'r')
axis([0 80 -5 5])