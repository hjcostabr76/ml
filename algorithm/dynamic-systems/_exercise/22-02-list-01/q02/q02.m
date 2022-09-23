
h = [0 0 0 3 2.5 1 0 -1 0 .5 0 0 0 ];
x = [0 0 0 1 2 3 2 2 1 0 0 0 0];
y = circularConvolution(x, h);

%% Print graphs
subplot(3, 1, 1)
stem(1:25, [x zeros(1, 25 - length(x))]);
title('x')
grid on

subplot(3, 1, 2)
stem(1:25, [h zeros(1, 25 - length(h))]);
title('h')
grid on

% Custom implementation test
subplot(3, 1, 3)
stem(1:25, y);
title('y (custom)')
grid on
ylim([-5 20])

% MATLAB native function test (to compare)
stem(1:25, cconv(x, h));
title('y (matlab)')
ylim([-5 20])
grid on