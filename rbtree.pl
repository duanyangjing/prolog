% e represents empty tree, same as null in binaryTree.pl
rbtree(e).
rbtree(n(_, _, L, R)) :- rbtree(L), rbtree(R).

find(n(Val, _, _, _), Val).
find(n(Val, _, L, _), X) :- X < Val, find(L, X).
find(n(Val, _, _, R), X) :- X > Val, find(R, X).

% added cut here to make sure no need to try to satisfy balance(T,T).
balance(n(Z, blk, n(X, red, A, n(Y, red, B, C)), D), 
	n(Y, red, n(X, blk, A, B), n(Z, blk, C, D))) :- !.
balance(n(Z, blk, n(Y, red, n(X, red, A, B), C), D), 
	n(Y, red, n(X, blk, A, B), n(Z, blk, C, D))) :- !.
balance(n(X, blk, A, n(Z, red, n(Y, red, B, C), D)), 
	n(Y, red, n(X, blk, A, B), n(Z, blk, C, D))) :- !.
balance(n(X, blk, A, n(Y, red, B, n(Z, red, C, D))), 
	n(Y, red, n(X, blk, A, B), n(Z, blk, C, D))) :- !.
balance(T, T).

% empty tree insert as red
rbtree_insert(e, X, n(X, red, e, e)).
rbtree_insert(n(X, Color, L, R), X, n(X, Color, L, R)).
rbtree_insert(n(Val, Color, L, R), X, T) :-
	X < Val, rbtree_insert(L, X, Lx), balance(n(Val, Color, Lx, R), T). 
rbtree_insert(n(Val, Color, L, R), X, T) :-
	X > Val, rbtree_insert(R, X, Rx), balance(n(Val, Color, L, Rx), T). 


insert(e, X, n(X, blk, e, e)).
insert(n(Val, Color, L, R), X, n(A, blk, C, D)) :- 
	rbtree_insert(n(Val, Color, L, R), X, n(A, _, C, D)).