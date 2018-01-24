function results = balloon(t, y, wind, V, bouyant)
  % PARAMS:
  % t, y    -> values of time and [3-vector pos, 3-vector vel] from ode45
  % wind    -> 3-vector (N, E, D) of wind speeds (m/s)
  % V       -> volume (m^3)
  % bouyant -> magnitude of the bouyancy force of the balloon

  m    = 0.5;  % kg
  g    = 9.81; % m/s^2
  Cd   = 0.5;  % drag coeff

  pos = y(1:3); % position (N, E, D)
  vel = y(4:6);

  diameter = (6*V/pi)^(1/3); % diameter of a sphere of V m^3

  relative_wind = wind' - vel;
  q = 0.5*1.225* norm(relative_wind)^2;

  fDrag     = q * Cd * diameter * unit(relative_wind); % drag force
  fBouyancy = bouyant * [0; 0; -1];                    % bouyant force vector
  fGrav     = m * g * [0; 0; 1];                       % gravity

  dPos = vel; % time derivative of position is velocity
  dVel = (fDrag + fBouyancy + fGrav)/m; % a = sum(F)/m

  results = [dPos; dVel];
end

% unit vector in the given direction
function out = unit(vec)
  out = vec/norm(vec);
end
