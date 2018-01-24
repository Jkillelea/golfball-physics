% Jacob Killelea - ASEN 3128 - Assigment 1
% balloon simulation
clear all; clc;

V    = 1;    % m^3
g    = 9.81; % m/s^2
tmax = 1000; % seconds

pos0 = [0, 0, 0]; % north, east, down
vel0 = [0, 0, 0]; % (m/s)
wind = [4, 2, 0]; % (m/s)

% densities
rho_air = 1.2250; % sea level STP (kg/m^3)
rho_he  = 0.1785; % https://www.engineeringtoolbox.com/gas-density-d_158.html 

initial_conds = [pos0, vel0];
volumes = zeros(20, 1);

% iterate through each windspeed and look for the volume that'll lift it at
% a 45 degree angle
for windspeed = 1:20 % m/s, crosswind
  wind = windspeed * [1, 0, 0];
  V = 0.3*windspeed; % starting volume
  p = [1, 0];

  while(p(1) <= 1) % while slope is less than 1, increase the volume
    bouyant = g*V*(rho_air - rho_he); % weight of displaced air minus weight of helium

    [t, y] = ode45(@(t, y) balloon(t, y, wind, V, bouyant), ...
                           [0, tmax],                       ...
                           initial_conds );
    north =  y(:, 1);
    east  =  y(:, 2);
    up    = -y(:, 3);

    p = polyfit(north, up, 1);
    volumes(windspeed) = V;
    % fprintf('wind %d, vol %f, slope %f\n', windspeed, V, p(1))
		% fprintf('.');

    V = 1.1*V;
  end
end
disp(' ');

plot(1:20, volumes);
title('Minimum Volume vs Crosswind for a 45 degree ascent');
xlabel('Crosswind Speed (m/s)');
ylabel('Balloon Volume (m^3)');

