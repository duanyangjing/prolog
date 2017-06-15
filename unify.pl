% X first order term is X constant, variable, or compound term
const(X) :- string(X).
const(X) :- number(X).
variable(X) :- string(X).

occurs(X, [X|_]) :- variable(X).
occurs(X, [compterm(_, L)|_]) :- variable(X), occurs(X, L).
occurs(X, [_|T]) :- variable(X), occurs(X, T). 

unify(X, X) :- const(X).
unify(X, Y, [(Y, X)]) :- const(X), variable(Y).
unify(X, compterm(F, L), [(X, compterm(F, L))]) :- 
	variable(X), not(occurs(X, L)).

unify(compterm(F, L1), compterm(F, L2), U) :-

