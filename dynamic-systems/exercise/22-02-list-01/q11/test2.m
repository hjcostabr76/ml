
[alpha,V] = ndgrid(0:3:15, 300:50:600);

domain = struct('alpha',alpha,'V',V);
shapefcn = @(x,y) [x,y,x*y];  % or use polyBasis('canonical',1,2)

K = tunableSurface('K',1,domain,shapefcn);
Ktuned = setData(K,[100,28,40,10]);
viewSurf(Ktuned);
