function results = golfball(t, conds)
  % golf ball physics simulation, called from ode45
  pos  = conds(1:3); % North, East, Down coords
  vel  = conds(4:6);
  m    = conds(7); % kg
  d    = conds(8); % m
  Cd   = conds(9); % coeff drag
  wind = conds(10:12); % coeff drag
  g    = 9.81;     % m/s^2
  rho  = 1.225;    % kg/m^3 (sea level density)

  % change in position = velocity
  dpos = vel;

  relative_wind = vel - wind;
  v         = norm(relative_wind);
  q         = 0.5*rho*v^2;
  aero_drag = q*Cd*d; % CHECK this

  % change in velocity = acceleration
  dvel = -aero_drag*unit(relative_wind)/m + g*[0; 0; 1]; % g points down
  
  dm    = 0; % no change in mass, diameter, or Cd
  dd    = 0;
  dCd   = 0;
  dWind = [0, 0, 0]; % wind doesn't change

  results = [dpos', dvel', dm, dd, dCd, dWind]';
end

% unit vector in the given direction
function out = unit(vec)
  out = vec/norm(vec);
end
