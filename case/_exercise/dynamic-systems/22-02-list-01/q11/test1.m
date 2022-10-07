clc; clear; close all;

w = linspace(-pi, pi, 100); % Freq spacing
r = linspace(0, 1, 30); % Radius spacing
[wG, rG] = meshgrid(w, r); % 2D cartesian grid

% Complex variable z (grid)
e = exp(1);
zG = rG .* e.^(j*wG);

%% Calculate the function

% 2nd order FIR notch filter
f = 5e3; % Notch filter
Fs = 44.1e3; % Sample rate
H = (zG - e^(j*2*pi / Fs)) .* (zG - e^(-j*2*pi*f / Fs));

% Extract magniture & phase
mag = 20*log10(abs(H));
ang = unwrap(angle(H));

% Create rectangular grid for 'surf' function
X = rG .* cos(wG);
Y = rG .* sin(wG);
surf(X, Y, mag, ang);
xlabel('Real');
ylabel('Imaginary');
zlabel('Level (dB)');
grid on;
