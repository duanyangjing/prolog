% X first order term is X constant, variable, or compound term
% constant and variable are identified using rules
% compound term has a functor compterm(fun symbol, list of args)
const(X) :- string(X).
const(X) :- number(X).
variable(X) :- string(X).

unify(X, X) :- const(X).
unify(X, Y, [(Y, X)]) :- const(X), variable(Y).
unify(X, compterm(F, L), [(X, compterm(F, L))]) :- 
	variable(X), not(occurs(X, L)).

unify(compterm(F, []), compterm(F, []), []).
unify(compterm(F, Args1), compterm(F, Args2), U) :-
	unify_args(Args1, Args2, U).

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
elimX(e(X, T), X, T).
elimX(e(X, T), compterm(F, L), compterm(F, NL)) :-
	elimX_list(e(X, T), L, NL).
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


%% equivalent transformation of equations to solvable form
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
trans([e(X, X)|Tail], NTail) :- variable(X), trans(Tail, NTail).

% transformation c: term reduction
% expand e(t1, t2)
trans([e(compterm(f, L1), compterm(f, L2))|Tail], L) :-
	args_to_equations(L1, L2, Es),
	trans(Tail, NTail),
	append(Es, NTail, L).

% transformation d: variable elimination
% X is a variable, not occurs in T, T neq X, apply variable elimination
trans([e(X, T)|Tail], NTail) :-
	variable(X),
	not(occurs(X, T)),
	elimXs(e(X, T), Tail, NTail). 
