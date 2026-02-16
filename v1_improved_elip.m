% Geometry & Material
L = 5;                      % Half-span (m)
                % Total lift (N)
W = 5000;       % Lift on half-wing (N)
rho_al = 2700;              % Density of Aluminum (kg/m^3)
sigma_yield = 240e6;        % Yield strength of Al 6061-T6 (Pa)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tapered Cross-section properties (Root to Tip)
b_root = 0.65; b_tip = 0.40; % Width tapers from 65cm to 40cm
h_root = 0.12; h_tip = 0.08; % Height tapers from 12cm to 8cm

% Spanwise coordinate
x = linspace(0, L, 300);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. Elliptical Lift Distribution
% Formula: w(x) = w0 * sqrt(1 - (x/L)^2)
% Total Lift = (pi * w0 * L) / 4 -> solve for w0
w0 = (4 * W) / (pi * L);
w = w0 * sqrt(1 - (x/L).^2);

%% 2. Varying Geometry (Taper)
t_skin = 0.002;   % 2 mm
t_spar = 0.004;   % 4 mm

b = linspace(b_root, b_tip, 300);
h = linspace(h_root, h_tip, 300);
I = 2*(b .* t_skin).*(h/2).^2;         % Moment of Inertia varies along span
y_max = h / 2;                         % Distance to outer fiber varies

A= 2*b.*t_skin + 2*h.*t_spar;

% Weight distribution (N/m) = Area * Density * Gravity
w_weight = A * rho_al * 9.81;

% Net Load = Lift (Up) - Weight (Down)
w_net = w - w_weight;

% Shear Force V (integral of net load)
V = flip(cumtrapz(x, flip(w_net))); 

% Bending Moment M (integral of shear)
M = flip(cumtrapz(x, flip(V)));

%% 4. Bending Stress and Safety Factor
sigma = (M .* y_max) ./ I;
FoS = sigma_yield ./ max(sigma);

%% 5. Plotting
figure('Color', 'w', 'Position', [100, 100, 1000, 400]);

% Plot Bending Moment
subplot(1,2,1);
plot(x, M, 'r', 'LineWidth', 2);
grid on; xlabel('Span position x (m)'); ylabel('Moment M (N·m)');
title('Elliptical Bending Moment');

% Plot Stress with Yield Limit
subplot(1,2,2);
plot(x, sigma / 1e6, 'b', 'LineWidth', 2); hold on;
yline(sigma_yield / 1e6, 'r--', 'Yield Strength', 'LabelHorizontalAlignment', 'left');
grid on; xlabel('Span position x (m)'); ylabel('Stress \sigma (MPa)');
title(['Bending Stress (Min FoS: ', num2str(FoS, '%.2f'), ')']);


fprintf('The Minimum Factor of Safety is: %.2f\n', FoS);



fprintf('The Minimum Factor of Safety is: %.2f\n', FoS);


