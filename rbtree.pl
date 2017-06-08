% e represents empty tree, same as null in binaryTree.pl
rbtree(e).
rbtree(n(_, _, L, R)) :- rbtree(L), rbtree(R).

rbtree_find(n(Val, _, _, _), Val).
rbtree_find(n(Val, _, L, _), X) :- X < Val, rbtree_find(L, X).
rbtree_find(n(Val, _, _, R), X) :- X > Val, rbtree_find(R, X).

balance(n(Z, blk, n(X, red, A, n(Y, red, B, C)), D), 
	n(Y, red, n(X, blk, A, B), n(Z, blk, C, D))).
balance(n(Z, blk, n(Y, red, n(X, red, A, B), C), D), 
	n(Y, red, n(X, blk, A, B), n(Z, blk, C, D))).
balance(n(X, blk, A, n(Z, red, n(Y, red, B, C), D)), 
	n(Y, red, n(X, blk, A, B), n(Z, blk, C, D))).
balance(n(X, blk, A, n(Y, red, B, n(Z, red, C, D))), 
	n(Y, red, n(X, blk, A, B), n(Z, blk, C, D))).
balance(T, T).

% empty tree insert as red
rbtree_insert(e, X, n(X, red, e, e)).
rbtree_insert(n(X, Color, L, R), X, n(X, Color, L, R)).
rbtree_insert(n(Val, Color, L, R), X, n(Valbalance, Colorbalance, Lbalance, Rbalance)) :-
	X < Val, rbtree_insert(L, X, T1), 
	balance(n(Val, Color, T1, R), n(Valbalance, Colorbalance, Lbalance, Rbalance)). 
rbtree_insert(n(Val, Color, L, R), X, n(Valbalance, Colorbalance, Lbalance, Rbalance)) :-
	X > Val, rbtree_insert(R, X, T1),
	balance(n(Val, Color, L, T1), n(Valbalance, Colorbalance, Lbalance, Rbalance)). 


rbt_ins(e, X, n(X, blk, e, e)).
rbt_ins(n(Val, Color, L, R), X, n(A, blk, C, D)) :- 
	rbtree_insert(n(Val, Color, L, R), X, n(A, _, C, D)).