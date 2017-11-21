% =========================================================================== %
%                               Grid Representation                           %
% =========================================================================== %

% ROP
% .##
% .T.

% Grid Dimensions
grid_size(3, 3).

% R2D2 initial Location
r2d2_init_location(location(1, 1)).

% Teleport Location
teleport(location(3, 2)).

% Rocks Locations
rock_location(location(1, 2)).
rock_location(location(8, 8)).  % dummy

% Pressure Pads Locations
pressure_pad(location(1, 3)).
pressure_pad(location(8, 8)).   % dummy

% Obstacles Locations
obstacle(location(2, 2)).
obstacle(location(2, 3)).
obstacle(location(9, 9)).   % dummy
