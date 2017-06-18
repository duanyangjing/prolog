% X first order term is X constant, variable, or compound term
% constant and variable are identified using rules
% compound term has a functor compterm(fun symbol, list of args)
const(X) :- string(X).
const(X) :- number(X).
variable(X) :- string(X).

unify(Term1, Term2, U) :- 
	trans([e(Term1, Term2)], U).

%------------------------------------------------------------------------------%
%%% relations used in trans() relation
%
% compterm args as a list * args list * equation list
args_to_equations([], [], []).
args_to_equations([H1|T1], [H2|T2], [e(H1, H2)|T]) :-
	args_to_equations(T1, T2, T).

% check whether variable X appear in a compound term 
% (will not appear in const and variable)
occurs_aux(X, [X|_]).
occurs_aux(X, [compterm(_, L)|_]) :- occurs_aux(X, L).
occurs_aux(X, [_|T]) :- occurs(X, T). 
occurs(X, compterm(_, L)):- occurs_aux(X, L). 

% substitute variable X with T in a term
% This term could be a var, compterm or constant, each is mutually exclusive
elimX(e(X, T), X, T) :- !.
elimX(e(X, T), compterm(F, L), compterm(F, NL)) :-
	elimX_list(e(X, T), L, NL), !.
elimX(e(X, T), Term, Term).

% substitute variable X with T in a list of terms, can be used to handle
% list of terms of a compterm
elimX_list(e(_, _), [], []).
elimX_list(e(X, T), [X|Tail], [T|NTail]) :- 
	elimX_list(e(X, T), Tail, NTail).
elimX_list(e(X, T), [compterm(F, L)|Tail], [compterm(F, NL)|NTail]) :-
	elimX_list(e(X, T), L, NL),
	elimX_list(e(X, T), Tail, NTail).
elimX_list(e(X, T), [Term|Tail], [Term|NTail]) :- 
	elimX_list(e(X, T), Tail, NTail).

% apply variable elimiation X -> T for all other equations
elimXs(e(X, T), [], []).
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
	not(variable(T)), variable(X),
	not(occurs(X, T)), 
	elimXs(e(X, T), Tail, Tail1),
	trans(Tail1, Tail2).

% transformation b: erase e(x, x)
% x = x where x is a variable, erase the euqation.
% actually, not only when x is var, also should erase
trans([e(X, X)|Tail], NTail) :- variable(X), trans(Tail, NTail).
trans([e(X, X)|Tail], NTail) :- const(X), trans(Tail, NTail).

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
	variable(X),
	not(occurs(X, T)),
	elimXs(e(X, T), Tail, Tail1),
	trans(Tail1, NTail). 




%------------------------------------------------------------------------------%
%%% Sample tests

%%% simple tests
% unify(1, 1, U).
% unify(1, 2, U).
% unify("X", 1, U).
% unify(1, "X", U).
% unify("X", "X", U).
% unify("X", "Y", U).

%%% compound term tests
% unify(compterm(f, [1]), compterm(f, ["X"]), U).
% unify(compterm(f, [compterm(g, [1])]), compterm(f, [compterm(g, ["X"])]), U).
% unify(compterm(f, [compterm(h,[compterm(g, [1])])]), compterm(f, [compterm(h,[compterm(g, ["X"])])]), U).

%%% test unification consistency
% unify(compterm(f, [1,2]), compterm(f, ["X","X"]), U).

%%% test var sharing
% unify(compterm(f, ["X","Y","Z"]), compterm(f, ["Y","Z",1]), U).
% unify(compterm(f, ["X","Y"]), compterm(f, ["Y","X"]), U).
