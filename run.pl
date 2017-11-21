% =========================================================================== %
%                                   Query                                     %
% =========================================================================== %
search([]):-
    search([compressed(true)]).

search(Options):-
    Options = [compressed(C)],
    plan(LR, Depth), compress(LR, C, R),
    format("depth limit = ~p\n", [Depth]),
    print_term(R, [indent_arguments(false)]).

compress(L, false, L).

compress(L, true, R):-
    compress_list(L, R, 0).

compress_list([], [], _).
compress_list([H], [(H, Count2)], Count):-
    Count2 is 1 + Count.

compress_list([H1, H2 | T], [(H1, Count2)|R], Count):-
    H1 \= H2, Count2 is 1 + Count,
    compress_list([H2 | T], R, 0).

compress_list([H, H | T], R, Count):-
    Count2 is 1 + Count,
    compress_list([H | T], R, Count2).

plan(LR, Depth):-
    depth_limit(Depth_Limit),
    call_with_depth_limit(goal_test(S), Depth_Limit, Depth),
    Depth \= depth_limit_exceeded,
    action_sequence(S, L),
    reverse(L, LR).

plan([], Depth):-
    depth_limit(Depth_Limit),
    Depth = depth_limit_exceeded,
    call_with_depth_limit(goal_test(_), Depth_Limit, Depth).



action_sequence(S, []):-
    S \= result(_, _).

action_sequence(S, [H|T]):-
    S = result(H, S2),
    action_sequence(S2, T).

% Loads the initial situation
:- [facts].

action(north, -1, 0).
action(east, 0, 1).
action(south, 1, 0).
action(west, 0, -1).

% =========================================================================== %
%                                 Goal Test                                   %
% =========================================================================== %
goal_test(S):-
    teleport(X), robot(X, S).

% =========================================================================== %
%                            Successor-State Axioms                           %
% =========================================================================== %
robot(Cell, s0):-
    r2d2_init_location(Cell).

robot(Cell1, result(A, S)):-
    in_grid(Cell1), Cell1 = location(X, Y), action(A, DX, DY),
    PX is X - DX, PY is Y - DY, Cell2 = location(PX, PY),
    valid_move(Cell2, Cell1, A, S), robot(Cell2, S).

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

% Checks that location (X, Y) is inside the grid.
in_grid(location(X, Y)):-
    grid_size(N, M), X > 0, Y > 0, X =< N, Y =< M.

free_cell(Cell, S):-
    \+ teleport(Cell), \+ obstacle(Cell), \+ rock(Cell, S).

valid_move(Cell1, Cell2, A, S):-
    in_grid(Cell1),
    (free_cell(Cell2, S);
     teleport(Cell2), active_teleport(S);
     movable_rock(Cell1, Cell2, _, A, S)
    ).

movable_rock(Cell1, Cell2, Cell3, A, S):-
    action(A, DX, DY), Cell2 = location(X2, Y2),
    Cell1 = location(X1, Y1), X1 is X2 - DX, Y1 is Y2 - DY,
    Cell3 = location(X3, Y3), X3 is X2 + DX, Y3 is Y2 + DY,
    in_grid(Cell3), free_cell(Cell3, S), rock(Cell2, S), robot(Cell1, S).
% movable_rock(C1, C2, A, S): true if C1 is a rock and C2 is a free cell in
% situation S and the rock will move from C1 to C2 if pushed using action A.
% C1 is unified, C2 is the target variable to unify.
% movable_rock(Cell1, Cell2, A, S):-
%     Cell1 = location(X, Y), action(A, DX, DY),
%     X2 is X + DX, Y2 is Y + DY, Cell2 = location(X2, Y2),
%     in_grid(Cell2), free_cell(Cell2, S), rock(Cell1, S).

% valid_rock_move(C1, C2, A, S): true if moving a rock from C1 to C2 is valid.
%
% valid_rock_move(Cell1, Cell2, A, S):-
%     Cell1 = location(X, Y), action(A, DX, DY), PX is X - DX, PY is Y - DY,
% robot(location(PX, PY), S), movable_rock(Cell1, Cell2, A, S).

% robot_away(Cell, A, S): true if the robot at situation result(A, S) is not at Cell.
robot_away(location(X, Y), A, S):-
    action(A, DX, DY), PX is X - DX, PY is Y - DY, \+ robot(location(PX, PY), S).

% active_teleport(S): true the teleport is active in situation S.
active_teleport(S):-
    setof(Cell, pressure_pad(Cell), L), check_pads(L, S).

% check_pads(P, S): true if each pad cell in list P has a rock in situation S.
check_pads([], _).

check_pads([H|T], S):-
    rock(H, S), check_pads(T, S).
