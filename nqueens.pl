% attack holds if two queens at the two positions can attack each other
% This can happen for three cases: horizontal, vertical or diagonal
attack(pos(_, Y), pos(_, Y)).
attack(pos(X, _), pos(X, _)).
attack(pos(X, Y), pos(X1, Y1)) :- abs(X1 - X) =:= abs(Y1 - Y).


% validPos holds if P is a valid position given a list of moves
validPos([], _).
validPos([H|T], P) :- not(attack(H, P)), validPos(T, P).


% next holds if pos(X, Y) is a valid next step given a list of moves
next(N, X, Moves, pos(X, Y)) :-
	between(1, N, Y),
	validPos(Moves, pos(X, Y)).

nqueens_aux(N, N, Moves, Moves).
nqueens_aux(N, X, Moves, Ans) :- 
	X1 is X + 1,
	next(N, X1, Moves, Next),
	nqueens_aux(N, X1, [Next|Moves], Ans).

nqueens(N, Ans) :- nqueens_aux(N, 0, [], Ans).
