fs = 1000;
N = 25;
t = 1:N;

%% x1
x1 = getSine(3, 400, fs, 0, N);
subplot(3, 1, 1);
stem(t, x1);
title('x1[nT]');

%% x2
x2 = getSine(2, 270, fs, pi / 4, N);
subplot(3, 1, 2);
stem(t, x2);
title('x2[nT]');

%% x3
x3 = getSine(-4, 750, fs, -pi / 2, N);
subplot(3, 1, 3);
stem(t, x3);
title('x3[nT]');