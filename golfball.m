function results = golfball(t, conds)
  pos = conds(1:3); % North, East, Down coords
  vel = conds(4:6);
  m   = conds(7); % kg
  d   = conds(8); % m
  Cd  = conds(9); % coeff drag
  g   = 9.81;     % m/s^2
  rho = 1.225;    % kg/m^3 (sea level density)

  % change in position = velocity
  dpos = vel;

  v         = norm(vel);
  q         = 0.5*rho*v^2;
  aero_drag = q*Cd*d; % CHECK this

  % change in velocity = acceleration
  dvel = -aero_drag*unit(vel)/m + g*[0; 0; 1]; % g points down
  
  dm  = 0; % no change in mass, diameter, or Cd
  dd  = 0;
  dCd = 0;

  results = [dpos', dvel', dm, dd, dCd]';
end

% unit vector in the given direction
function out = unit(vec)
  out = vec/norm(vec);
end
