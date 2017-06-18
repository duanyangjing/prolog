% attack range for queen at pos(X, Y)
attack(N, pos(X, Y), pos(X1, Y)).
attack(N, pos(X, Y), pos(X, Y1)).
attack(N, pos(X, Y), pos(X1, Y1)) :- abs(X1 - X) =:= abs(Y1 - Y).


% P is a valid position given a list of moves
validPos(N, [], P).
validPos(N, [H|T], P) :- not(attack(N, H, P)), validPos(N, T, P).


% pos(X, Y) is a valid next step given a list of moves
next(N, X, Moves, pos(X, Y)) :-
	between(1, N, Y),
	validPos(N, Moves, pos(X, Y)).

nqueens_aux(N, N, Moves, Moves).
nqueens_aux(N, X, Moves, Ans) :- 
	X1 is X + 1,
	next(N, X1, Moves, Next),
	nqueens_aux(N, X1, [Next|Moves], Ans).

nqueens(N, Ans) :- nqueens_aux(N, 0, [], Ans).