% =========================================================================== %
%                            Problem Definition                               %
% =========================================================================== %

% Initial situation
:- [facts].

% Actions
action(north, -1, 0).
action(east, 0, 1).
action(south, 1, 0).
action(west, 0, -1).

% Goal test
goal_test(S):-
    teleport(X), robot(X, S).

% =========================================================================== %
%                            Successor-State Axioms                           %
% =========================================================================== %

% Robot Axiom
robot(Cell, s0):-
    r2d2_init_location(Cell).

robot(Cell1, result(A, S)):-
    in_grid(Cell1), Cell1 = location(X, Y), action(A, DX, DY),
    PX is X - DX, PY is Y - DY, Cell2 = location(PX, PY),
    valid_move(Cell2, Cell1, A, S), robot(Cell2, S).

% Rock Axiom
rock(Cell, s0):-
    rock_location(Cell).

rock(Cell1, result(A, S)):-
    in_grid(Cell1),
    (robot_away(Cell1, A, S), rock(Cell1, S);
    action(A, DX, DY), Cell1 = location(X, Y), NX is X - DX, NY is Y - DY,
    Cell2 = location(NX, NY), movable_rock(_, Cell2, Cell1, A, S)).

%============================================================================ %
%                             Axioms Constraints                              %
% =========================================================================== %

% in_grid(C): true if cell C is inside the grid.
in_grid(location(X, Y)):-
    grid_size(N, M), X > 0, Y > 0, X =< N, Y =< M.

% free_cell(C, S): true if cell C is empty at situation S.
free_cell(Cell, S):-
    \+ teleport(Cell), \+ obstacle(Cell), \+ rock(Cell, S).

% valid_move(C1, C2, A, S): true if the robot can move from C1 to C2 if it
% does action A in situation S.
valid_move(Cell1, Cell2, A, S):-
    in_grid(Cell1), (free_cell(Cell2, S); active_teleport(Cell2, S);
    movable_rock(Cell1, Cell2, _, A, S)).

% movable_rock(C1, C2, C3, A, S): true if at situation S there is a robot is at
% C1, a rock at C2, a free cell at C3 and the rock will move from C2 to C3 if
% the robot does action A.
movable_rock(Cell1, Cell2, Cell3, A, S):-
    action(A, DX, DY), Cell2 = location(X2, Y2),
    Cell1 = location(X1, Y1), X1 is X2 - DX, Y1 is Y2 - DY,
    Cell3 = location(X3, Y3), X3 is X2 + DX, Y3 is Y2 + DY,
    in_grid(Cell3), free_cell(Cell3, S), rock(Cell2, S), robot(Cell1, S).

% robot_away(Cell, A, S): true if the robot at situation result(A, S) is not at Cell.
robot_away(location(X, Y), A, S):-
    action(A, DX, DY), PX is X - DX, PY is Y - DY, \+ robot(location(PX, PY), S).

% active_teleport(Cell, S): true if the teleport at Cell is active in situation S.
active_teleport(Cell, S):-
    teleport(Cell), setof(C, pressure_pad(C), L), check_pads(L, S).

% check_pads(P, S): true if each pad cell in list P has a rock in situation S.
check_pads([], _).

check_pads([H|T], S):-
    (\+ in_grid(H); rock(H, S)), check_pads(T, S).
