% Data (this length was chosen because the typical span lenght of a UAV is between 6m-12m
% after research, i found that Aluminium 6061-T6 is a good choice as it is typical material choice for this kind if aircraft)
L = 5; 
                
W = 10000;       
density = 2700;              
yield = 240e6;        % Yield strength of Al 6061 T6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Taper (almost every aircraft wing tapers twards the root, i have chosen taper percentage of approx 40% for the base and 30% for the height)
b_root = 0.65; b_tip = 0.40; % Width tapers from 65cm to 40cm
h_root = 0.08; h_tip = 0.0547; % Height tapers from 8cm to 5.5cm


x = linspace(0, L, 300); %(because the wing tapers, we need to find the below calcualations at every single point along the span, 300 points were chosn for now)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Lift
% Formula: w(x) = w0 * sqrt(1 - (x/L)^2)       (this formula is for an eliptical weight distribution which is considerably accurate and close to the real one)
% Total_Lift = (pi * w0 * L) / 4               (area of a quarter of a circle)
w0 = (4 * W) / (pi * L);
w = w0 * sqrt(1 - (x/L).^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Geometry             (the following thickness were chosen to acheive the max bending resistance while maintaining low mass )
t_skin = 0.002;  
t_spar = 0.004;       %(only carry shear and small contribution to bending)
w_spar_f = 0.030;     %(width of 30cm subject to further development)
w_spar_r = 0.020;

b = linspace(b_root, b_tip, 300);
h = linspace(h_root, h_tip, 300);

I_skin = 2 * (b .* t_skin) .* (h/2).^2;
I_front = (1/12)*w_spar_f*h.^3 - (1/12)*(w_spar_f - 2*t_spar)*(h - 2*t_spar).^3;
I_rear = (1/12)*t_spar*h.^3 + 2*(w_spar_r * t_spar * (h/2).^2);
I = I_skin + I_front + I_rear;

A_skin = 2 * (b .* t_skin);
A_front = 2 * (w_spar_f * t_spar) + 2 * (h * t_spar); 
A_rear = 2 * (w_spar_r * t_spar) + (h * t_spar);   % (the rear spar is a c channel; most aircraft use the )
A = A_skin + A_front + A_rear;                     % (surface area of skins and spars to later calculate mass)

y_max = h / 2;     %(neutral axis)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Weight
weight = A * density * 9.81;   %(this calculated weight does not account for ribs)

% Net Load
load = w - weight;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Shear Force V
V = flip(cumtrapz(x, flip(load))); 

% Bending Moment
M = flip(cumtrapz(x, flip(V)));

% 4. Bending Stress and Safety Factor
sigma = (M .* y_max) ./ I;
FoS = yield ./ max(sigma);       %(Factor of Safety is the margin of allowed error that the  wing can comfortably and safely play around typically it should be 1.5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%shear stress
Q = A .* (h/4);
tau = ((V .* Q) ./ (I .* t_spar))/ 1e6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. Plotting
figure('Color', 'w', 'Position', [100, 100, 1200, 400]);

subplot(1,3,1);
plot(x, M, 'r', 'LineWidth', 2);
grid on; xlabel('Span position x (m)'); ylabel('Moment M (N·m)');
title('Bending Moment');

subplot(1,3,2);
plot(x, sigma / 1e6, 'b', 'LineWidth', 2); hold on;
yline(yield / 1e6, 'r--', 'Yield Strength', 'LabelHorizontalAlignment', 'left');
grid on; xlabel('Span position x (m)'); ylabel('Stress \sigma (MPa)');
title(['Bending Stress (Min FoS: ', num2str(FoS, '%.2f'), ')']);

subplot(1,3,3);
plot(x, tau, 'g', 'LineWidth', 2);
grid on;
xlabel('Span position x (m)');
ylabel('Shear stress \tau (MPa)');
title('Shear Stress Distribution');

fprintf('The Minimum Factor of Safety =: %.2f\n', FoS);  %(output 1.54 which is acceptable considering all assumptions made)


Total_Weight_Newtons = trapz(x, weight);
Total_Mass_kg = Total_Weight_Newtons / 9.81;
fprintf('Total Wing Mass: %.2f kg\n', Total_Mass_kg);  %(output 44.66kg which does not match th CAD model of approx 50kg, this is mainly because the model does not account for ribs and other support bars)
