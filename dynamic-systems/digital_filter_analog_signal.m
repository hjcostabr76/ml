clear all;

Ts = 1 / 4000;
t = 0:Ts:0.002;
x = 80*sin(2000*pi*t);

fig = figure;
set(fig, 'PaperType', 'a4', 'PaperOrientation', 'portrait');
plot(t, x, 'bo-');

A = 1;
B = [1 .75 .5 .25];
y = filter(B, A, x);

hold on;
plot(t, y, 'rx-');
hold off;
legend('Signal x(t)', 'Filtered Signal y(t)');

print('digital_filter_analog_signal_01', '-dpdf');;