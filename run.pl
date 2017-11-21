% =========================================================================== %
%                                   Query                                     %
% =========================================================================== %

% Example Query: search([]).

% Search Depth Limit
depth_limit(16).

% Load the problem
:- [r2d2].

% search(Options): searches for a solution as defined in the loaded problem.
% - The maximum depth used while searching is defined in depth_limit() fact.
% - Options: a list of options for printing. Current implemented options:
%            + compressed(Spec): defines how to display the action sequence.
%                * true (default): compress the action sequence (i.e. similar
%                                  consecutive are grouped and counted).
%                * false: leaves action sequence with consecutive repeated values.
search([]):-
    search([compressed(true)]).

search(Options):-
    Options = [compressed(C)],
    plan(LR, Depth), compress(LR, C, R),
    format("depth limit = ~p\n", [Depth]),
    print_term(R, [indent_arguments(false)]).

% plan(L, D): true if L is an action sequence that solves the defined problem
% without exceeding the depth limit D.
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


% action_sequence(S, T): true if T is a list of actions followed to reach
% situation S from the initial situation s0.
action_sequence(S, []):-
    S \= result(_, _).

action_sequence(S, [H|T]):-
    S = result(H, S2),
    action_sequence(S2, T).

% Compression predicates.
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
