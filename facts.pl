% Initial grid
%
% X Y 1 2 3 4 5
% 1   R . . . .
% 2   . . . P .
% 3   . O . . .
% 4   . . # A .
% 5   . . . . .

% R.
% PA
% R.

% R.OP
% O...
% ....
% P..T

% .T.
% PO.
% POR

% #T.
% OP..
% OP..
% OP.R
grid_size(6, 6).

r2d2_init_location(location(6, 6)).
teleport(location(1, 2)).

% rock_location(location(2, 2)).
% pressure_pad(location(2, 1)).

% rock_location(location(3, 2)).
% pressure_pad(location(3, 1)).

% rock_location(location(4, 2)).
% pressure_pad(location(4, 1)).

% grid_size(6, 6).
%
% r2d2_init_location(location(6, 6)).
% teleport(location(1, 2)).
%
% % rock_location(location(2, 2)).
% % rock_location(location(3, 2)).
% % rock_location(location(1, 3)).
rock_location(location(10, 10)).
pressure_pad(location(10, 10)).
% % pressure_pad(location(3, 1)).
% % pressure_pad(location(4, 1)).

obstacle(location(1, 1)).

depth_limit(15).
