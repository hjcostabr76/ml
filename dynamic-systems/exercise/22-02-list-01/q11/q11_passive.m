clear; clc; close all;

%% Parameters
R1 = 1e3;
R2 = 250;
L = 50e-3;
C = 1e-6;

fMax = 1e3;
f = -fMax:100:fMax;

[meshX, meshY] = meshgrid(f, f);
meshFlat = reshape(complex(meshX, meshY), [1 length(f)^2]);

%% Set system
polyZeros = [L R2];
polyPoles = [R1*L*C (R1*R2*C + L) (R1 + R2)];

H_sFlat = freqs(polyZeros, polyPoles, meshFlat);
H_jOmega = reshape(abs(H_sFlat), size(meshX));
phase = reshape(angle(H_sFlat), size(meshX));

%% Plot

% Magnitude
figure(1);

subplot(2, 1, 1);
surf(meshX, meshY, H_jOmega);
title('Magnitude Response');
xlabel('$\Re \{ s \} = \sigma$', 'Interpreter', 'latex');
ylabel('$\Im \{ s \} = j \omega$', 'Interpreter', 'latex');
zlabel('$|H(s)|$', 'Interpreter', 'latex');
grid on;

% Phase
subplot(2, 1, 2);
surf(meshX, meshY, phase);
title('Phase Response');
xlabel('$\Re \{ s \} = \sigma$', 'Interpreter', 'latex');
ylabel('$\Im \{ s \} = j \omega$', 'Interpreter', 'latex');
zlabel('$\theta(s)$', 'Interpreter', 'latex');
grid on;

%% TODO: REname
figure(2);

half = floor(length(f) / 2);
halfMesh1 = meshX(half+1:end, :);
halfMesh2 = meshY(half+1:end, :);
halfMesh3 = H_jOmega(half+1:end, :);

surf(halfMesh1, halfMesh2, halfMesh3);
title('Magnitude Response (imaginary axis enphasized)');
xlabel('$\Re \{ s \} = \sigma$', 'Interpreter', 'latex');
ylabel('$\Im \{ s \} = j \omega$', 'Interpreter', 'latex');
zlabel('$|H(s)|$', 'Interpreter', 'latex');
grid on;
