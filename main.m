% golf ball simulation

m    = 50/1000; % kg
d    = 3/100;   % diameter, meters
Cd   = 0.5;     % coeff of drag
g    = 9.81;    % m/s^2
tmax = 20;      % seconds

pos0 = [0,  0,   0]; % North, East, Down coords
vel0 = [0, 20, -20]; % m/s % 50g case

inital_conds = [pos0, vel0, m, d, Cd];
[t, y] = ode45(@golfball, [0, tmax], inital_conds);

north =  y(:, 1);
east  =  y(:, 2);
up    = -y(:, 3); % this convention is dumb

idx   = up > 0; % only positive height
north = north(idx);
east  = east(idx);
up    = up(idx);

fprintf('%.3f kg - range %.3f meters\n', ...
        m, max(east));

for m = 1:1000 % grams

  m    = m/1000;                % convert to kg
  vel0 = sqrt(20/m)*[0, 1, -1]; % KE is fixed 20J, so vary velocity to keep it const
  ke   = 0.5*m*norm(vel0)^2;
  inital_conds = [pos0, vel0, m, d, Cd];

  [t, y] = ode45(@golfball, [0, tmax], inital_conds);

  north =  y(:, 1);
  east  =  y(:, 2);
  up    = -y(:, 3); % this convention is dumb

  idx   = up > 0; % only positive height
  north = north(idx);
  east  = east(idx);
  up    = up(idx);

  fprintf('%.3f kg - KE %.0f J - range %.3f meters\n', ...
          m, ke, max(east));
end
