function xdot=dvCord(x,ux,uy,t)
%
% function xdot=dvCord(x,ux,uy,t)
% implements the Cord system
% x state vector
% the system has no inputs so ux=uy=0
% xd time derivative of x (vector field at x)

% The cord system

%
% First published in
%
% Aguirre, L.A., Letellier, C., Investigating observability properties from data in nonlinear dynamics�, 
% Phisical Reivew E, 83:066209, 2011. DOI: 10.1103/PhysRevE.83.066209.
%
% Analysed in
%
% Letellier, C., Aguirre, L.A., Required criteria for recognizing new types of chaos: Application to the �cord� attractor�, 
% Phisical Reivew E, 85:036204, 2012. DOI: 10.1103/PhysRevE.85.036204.

% % % % %minha area
% % % % a=150;
% % % % %vazao escolhida no inicio
% % % % q0=50;
% % % % %valor inicial de h1
% % % % h1=0;
% % % % %valor inicial de h2
% % % % h2=0;
% % % % %k1 - constante de vazzao
% % % % k1= 26.94
% % % % %k2
% % % % k2=13.13
% % % % 
% % % % 
% % % % 
% % % % hf1=h1+x(1)
% % % % hf2=h2+x(2)
% % % % 
% % % % q=q0+ux
% % % % q1 = sign(hf2-hf1)*k1*sqrt(abs(hf2-hf1));
% % % % q2 = k2*sqrt(hf2);
% % % 
% % % % xd(1) = (q+q1)/a;
% % % % xd(2) = (-q1-q2)/a;

xd(1) = (0.53*x(1)*x(2))/(0.45*x(2)^2+x(2)+0.12) - 0.3*x(1) - x(1)*ux;
xd(2) = - (1.325*x(1)*x(2))/ (0.45*x(2)^2 + x(2) + 0.12) - 0.3*x(2) + 1.2 - (x(2)-4)*ux;

xdot=xd';