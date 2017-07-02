% first order term X is constant, variable, or compound term
% constant: const('c')
% variable: var('v')
% compound term: compterm('f', [t1,t2,...tn])
% representation of unifier: 
% [e(X1, T1)...] where X is a variable, T can be any term.

% unify holds if U is a unifier of Term1 and Term2.
% will fail if the two terms do not unify.
unify(Term1, Term2, U) :- 
	trans([e(Term1, Term2)], U).

%------------------------------------------------------------------------------%
%%% relations used in trans() relation
%
% compterm args as a list * args list * equation list
args_to_equations([], [], []).
args_to_equations([H1|T1], [H2|T2], [e(H1, H2)|T]) :-
	args_to_equations(T1, T2, T).

% holds if variable X appear in the list of terms of a compound term 
% (will not appear in const and variable)
% when this relation gets called X is already checked to a var
occurs_aux(X, [X|_]).
occurs_aux(X, [compterm(_, L)|_]) :- occurs_aux(X, L).
occurs_aux(X, [_|T]) :- occurs(X, T).
% occurs(X, X). 
occurs(X, compterm(_, L)):- occurs_aux(X, L). 

% elimX(eqn, Term1, Term2) holds if Term2 results from Term1 substituted based 
% on equation eqn. X is already checked to be a variable when this relation
% gets called.
% Term1 could be a var, compterm or constant, each is mutually exclusive
elimX(e(X, T), X, T) :- !.
elimX(e(X, T), compterm(F, L), compterm(F, NL)) :-
	elimX_list(e(X, T), L, NL), !.
elimX(e(_, _), Term, Term).

% elimX_list(eqn, L1, L2) holds if Term list L2 results from all terms in L1 
% substituted based on equation eqn, can be used to handle list of terms of a 
% compterm. X is already checked to be a variable when this relation gets called.
elimX_list(e(_, _), [], []).
elimX_list(e(X, T), [X|Tail], [T|NTail]) :- 
	elimX_list(e(X, T), Tail, NTail).
elimX_list(e(X, T), [compterm(F, L)|Tail], [compterm(F, NL)|NTail]) :-
	elimX_list(e(X, T), L, NL),
	elimX_list(e(X, T), Tail, NTail).
elimX_list(e(X, T), [Term|Tail], [Term|NTail]) :- 
	elimX_list(e(X, T), Tail, NTail).

% elimXs(eqn, EqnL1, EqnL2) holds if Equation list L2 results from X -> T
% applied to all equations in EqnL1.  
elimXs(e(_, _), [], []).
elimXs(e(X, T), [e(Term1, Term2)|Tail], [e(Term1X, Term2X)|NTail]) :-
	elimX(e(X, T), Term1, Term1X),
	elimX(e(X, T), Term2, Term2X),
	elimXs(e(X, T), Tail, NTail).

%------------------------------------------------------------------------------%
%%% equivalent transformation of equations to solvable form
%
trans([],[]).
% transformation a: organize into form e(x, t) 
% t = x where t is not a variable, and x is a variable, switch x and t.
trans([e(T, X)|Tail], [e(X, T)|Tail2]) :- 
	not(T = var(_)), X = var(_),
	not(occurs(X, T)), 
	elimXs(e(X, T), Tail, Tail1),
	trans(Tail1, Tail2).

% transformation b: erase e(x, x)
% x = x where x is a variable, erase the euqation.
% actually, not only when x is var, also should erase
trans([e(X, X)|Tail], NTail) :- X = var(_), trans(Tail, NTail), !.
trans([e(X, X)|Tail], NTail) :- X = const(_), trans(Tail, NTail), !.

% transformation c: term reduction
% expand e(t1, t2)
trans([e(compterm(F, L1), compterm(F, L2))|Tail], NL) :-
	args_to_equations(L1, L2, Es),
	append(Es, Tail, L),
	trans(L, NL).

% transformation d: variable elimination
% X is a variable, not occurs in T, T neq X, apply variable elimination
% still need to keep the equation applied.
trans([e(X, T)|Tail], [e(X, T)|NTail]) :-
	X = var(_),
	not(occurs(X, T)),
	elimXs(e(X, T), Tail, Tail1),
	trans(Tail1, NTail). 


% helper relation to write unifier to screen
% show_term(var(X)) :- write(X).
% show_term(const(X)) :- write(X).
% show_term(compterm(F, L)) :- write(F), write("("), show_args(L).

% show_args([]) :- write(")").
% show_args([Term|Tail]) :- show_term(Term), write(","), show_args(Tail).

% show_eqn([e(X, T)]) :- write("e("), show_term(X), write(","), show_term(T), write(").").
% show_eqn([e(X, T)|Tail]) :- write("e("), show_term(X), write(","), show_term(T), write("), "), show_eqn(Tail).

%------------------------------------------------------------------------------%
%%% Sample tests

%%% simple tests
% unify(const(1), const(1), U).
% unify(const(1), const(2), U).
% unify(var("X"), const(1), U).
% unify(const(1), var("X"), U).
% unify(var("X"), var("X"), U).
% unify(var("X"), var("Y"), U).

%%% compound term tests
% unify(compterm("f", [const(1)]), compterm("f", [var("X")]), U).
% unify(compterm("f", [compterm("g", [const(1)])]), compterm("f", [compterm("g", [var("X")])]), U).
% unify(compterm("f", [compterm("h",[compterm("g", [const(1)])])]), compterm("f", [compterm("h",[compterm("g", [var("X")])])]), U).

%%% test unification consistency
% unify(compterm("f", [const(1),const(2)]), compterm("f", [var("X"),var("X")]), U).

%%% test var sharing
% unify(compterm("f", [var("X"),var("Y"),var("Z")]), compterm("f", [var("Y"),var("Z"),const(1)]), U).
% unify(compterm("f", [var("X"),var("Y")]), compterm("f", [var("Y"),var("X")]), U).
