clc; clear;

% Geometry
L = 3;                      % half-span (m)
W_total = 5000;             % total lift (N)
W_half = W_total / 2;       % lift on half-wing (N)

w0 = (2 * W_half) / L;      % peak load at root (N/m)

% Cross-section properties 
b = 0.20;                   % width (m)
h = 0.12;                   % height (m)
I = (b * h^3) / 12;         % second moment of area (m^4)
y_max = h / 2;              % outer fibre distance (m)

% Spanwise coordinate
x = linspace(0, L, 300);

% Distributed load
w = w0 * (1 - x / L);

% Bending moment distribution (triangular load)
M = (w0 / (6 * L)) * (L - x).^3;

% Bending stress distribution
sigma = (M * y_max) / I;

% Plots
figure;
plot(x, M, 'LineWidth', 2);
xlabel('Spanwise position x (m)');
ylabel('Bending moment M(x) (N·m)');
title('Bending moment distribution (triangular load)');
grid on;

figure;
plot(x, sigma / 1e6, 'LineWidth', 2);
xlabel('Spanwise position x (m)');
ylabel('Bending stress \sigma(x) (MPa)');
title('Bending stress distribution (triangular load)');
grid on;
