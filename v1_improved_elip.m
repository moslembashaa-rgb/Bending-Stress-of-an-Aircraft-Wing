% Data
L = 5; 
                
W = 10000;       
rho_al = 2700;              
sigma_yield = 240e6;        % Yield strength of Al 6061-T6 (Pa)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Taper
b_root = 0.65; b_tip = 0.40; % Width tapers from 65cm to 40cm
h_root = 0.08; h_tip = 0.0547; % Height tapers from 12cm to 8cm


x = linspace(0, L, 300);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Lift
% Formula: w(x) = w0 * sqrt(1 - (x/L)^2)
% Total Lift = (pi * w0 * L) / 4
w0 = (4 * W) / (pi * L);
w = w0 * sqrt(1 - (x/L).^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Geometry  (constant)
t_skin = 0.002;  
t_spar = 0.004;   
w_spar_f = 0.030; % 30mm width
w_spar_r = 0.020 

b = linspace(b_root, b_tip, 300);
h = linspace(h_root, h_tip, 300);

I_skin = 2 * (b .* t_skin) .* (h/2).^2;
I_front = (1/12) * t_spar .* h.^3;
I_rear = (1/12) * t_spar .* h.^3;
I = I_skin + I_front + I_rear;

A_skin = 2 * (b .* t_skin);
A_front = 2 * (w_spar_f * t_spar) + 2 * (h * t_spar); % Rectangular Hollow
A_rear = 2 * (w_spar_r * t_spar) + (h * t_spar);   % C-channel
A = A_skin + A_front + A_rear;

y_max = h / 2; 


A= 2*b.*t_skin + 2*h.*t_spar;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Weight
w_weight = A * rho_al * 9.81;

% Net Load
w_net = w - w_weight;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Shear Force V
V = flip(cumtrapz(x, flip(w_net))); 

% Bending Moment
M = flip(cumtrapz(x, flip(V)));

% 4. Bending Stress and Safety Factor
sigma = (M .* y_max) ./ I;
FoS = sigma_yield ./ max(sigma);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%shear stress
Q = A .* (h/4);
tau = (V .* Q) ./ (I .* t_spar);
tau_MPa = tau / 1e6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Plotting
figure('Color', 'w', 'Position', [100, 100, 1000, 400]);

subplot(1,2,1);
plot(x, M, 'r', 'LineWidth', 2);
grid on; xlabel('Span position x (m)'); ylabel('Moment M (N·m)');
title('Elliptical Bending Moment');

subplot(1,2,2);
plot(x, sigma / 1e6, 'b', 'LineWidth', 2); hold on;
yline(sigma_yield / 1e6, 'r--', 'Yield Strength', 'LabelHorizontalAlignment', 'left');
grid on; xlabel('Span position x (m)'); ylabel('Stress \sigma (MPa)');
title(['Bending Stress (Min FoS: ', num2str(FoS, '%.2f'), ')']);

subplot(1,3,3);
figure;
plot(x, tau_MPa, 'g', 'LineWidth', 2);
grid on;
xlabel('Span position x (m)');
ylabel('Shear stress \tau (MPa)');
title('Shear Stress Distribution');

fprintf('The Minimum Factor of Safety =: %.2f\n', FoS);



fprintf('The Minimum Factor of Safety =: %.2f\n', FoS);% Data
L = 5; 
                
W = 10000;       
rho_al = 2700;              
sigma_yield = 240e6;        % Yield strength of Al 6061-T6 (Pa)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Taper
b_root = 0.65; b_tip = 0.40; % Width tapers from 65cm to 40cm
h_root = 0.08; h_tip = 0.0547; % Height tapers from 8cm to 5cm


x = linspace(0, L, 300);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Lift
% Formula: w(x) = w0 * sqrt(1 - (x/L)^2)
% Total Lift = (pi * w0 * L) / 4
w0 = (4 * W) / (pi * L);
w = w0 * sqrt(1 - (x/L).^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Geometry (Taper)
t_skin = 0.002;  
t_spar = 0.004;   

b = linspace(b_root, b_tip, 300);
h = linspace(h_root, h_tip, 300);
I = 2*(b .* t_skin).*(h/2).^2;        
y_max = h / 2; 

A= 2*b.*t_skin + 2*h.*t_spar;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Weight
w_weight = A * rho_al * 9.81;

% Net Load
w_net = w - w_weight;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Shear Force V
V = flip(cumtrapz(x, flip(w_net))); 

% Bending Moment
M = flip(cumtrapz(x, flip(V)));

% 4. Bending Stress and Safety Factor
sigma = (M .* y_max) ./ I;
FoS = sigma_yield ./ max(sigma);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 5. Plotting
figure('Color', 'w', 'Position', [100, 100, 1000, 400]);

subplot(1,2,1);
plot(x, M, 'r', 'LineWidth', 2);
grid on; xlabel('Span position x (m)'); ylabel('Moment M (N·m)');
title('Elliptical Bending Moment');

subplot(1,2,2);
plot(x, sigma / 1e6, 'b', 'LineWidth', 2); hold on;
yline(sigma_yield / 1e6, 'r--', 'Yield Strength', 'LabelHorizontalAlignment', 'left');
grid on; xlabel('Span position x (m)'); ylabel('Stress \sigma (MPa)');
title(['Bending Stress (Min FoS: ', num2str(FoS, '%.2f'), ')']);


fprintf('The Minimum Factor of Safety is: %.2f\n', FoS);



fprintf('The Minimum Factor of Safety is: %.2f\n', FoS);
