%==========================================================================
% Universidade Federal de Minas Gerais
% Escola de Engenharia da UFMG
% Depto. de Engenharia El�trica
%
% Autor:
%   Lucas S. Batista
%
% Atualiza��o: 27/11/2020
%
% Nota:
%   Atualiza a solu��o corrente e a estrutura de vizinhan�a.
% =========================================================================


function [x,xr,xc,gx,xrpen,k] = neighborhoodChange(x,xr,xc,gx,xrpen, y,yr,yc,gy,yrpen, k)

if yrpen > xrpen
    x  = y;
    xr = yr;
    xc = yc;
    gx = gy;
    xrpen = yrpen;
    k  = 1;
else
    k  = k + 1;
end


