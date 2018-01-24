% golf ball simulation
% Jacob Killelea - ASEN 3128 - Assigment 1
clear all; clc;

% golf ball parameters
m    = 50/1000; % kg
d    = 3/100;   % diameter, meters
Cd   = 0.5;     % coeff of drag
g    = 9.81;    % m/s^2
tmax = 20;      % seconds

pos0 = [0,  0,   0]; % North, East, Down coords
vel0 = [0, 20, -20]; % m/s % 50g case
wind = [0,  0,   0];

% first simulation with given parameters
inital_conds = [pos0, vel0, m, d, Cd, wind];
[t, y]       = ode45(@golfball, [0, tmax], inital_conds);

north =  y(:, 1);
east  =  y(:, 2);
up    = -y(:, 3); % this convention is dumb

idx   = up > 0;   % only positive heights
north = north(idx);
east  = east(idx);
up    = up(idx);

fprintf('%.3f kg - range %.3f meters\n', ...
        m, max(east));

% vary the crosswind speed and see how it affects deflection
deflections = zeros(50, 1);
for w = 1:50 % m/s
  wind(1)      = w; % crosswind component
  inital_conds = [pos0, vel0, m, d, Cd, wind];
  [t, y]       = ode45(@golfball, [0, tmax], inital_conds);

  north =  y(:, 1);
  east  =  y(:, 2);
  up    = -y(:, 3); % this convention is dumb

  idx   = up > 0;   % only positive heights
  north = north(idx);
  east  = east(idx);
  up    = up(idx);

  deflections(w) = max(north);
end

figure; hold on; grid on;
title('Wind vs horizontal deflection');
xlabel('Wind Speed (m/s)');
ylabel('Horizontal Deflection');
plot(1:50, deflections, 'LineWidth', 2);


% constant kinetic energy (1/2)*m*V^2, vary mass and see what produces best range
m_range   = 1:1000;
distances = zeros(1, length(m_range));
wind      = [0, 0, 0];
for i = 1:length(m_range) % grams

  m    = m_range(i);
  m    = m/1000;                % convert to kg
  vel0 = sqrt(20/m)*[0, 1, -1]; % KE is fixed 20J, so vary velocity to keep it const
  ke   = 0.5*m*norm(vel0)^2;
  inital_conds = [pos0, vel0, m, d, Cd, wind];

  [t, y] = ode45(@golfball, [0, tmax], inital_conds);

  north =  y(:, 1);
  east  =  y(:, 2);
  up    = -y(:, 3);

  idx   = up > 0; % only positive height
  north = north(idx);
  east  = east(idx);
  up    = up(idx);

  distances(i) = max(east);
end

figure; hold on; grid on;
title('Range vs Weight, const 20J KE');
xlabel('mass (g)');
ylabel('distance');
plot(m_range, distances, 'LineWidth', 2);

