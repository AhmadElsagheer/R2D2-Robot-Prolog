% =========================================================================== %
%                               Grid Representation                           %
% =========================================================================== %

% #T.....
% .......
% .......
% .......
% .......
% .......
% ......R

% Grid Dimensions
grid_size(7, 7).

% R2D2 initial Location
r2d2_init_location(location(7, 7)).

% Teleport Location
teleport(location(1, 2)).

% Rocks Locations
rock_location(location(8, 8)).  % dummy

% Pressure Pads Locations
pressure_pad(location(8, 8)).   % dummy

% Obstacles Locations
obstacle(location(1, 1)).
obstacle(location(9, 9)).   % dummy
