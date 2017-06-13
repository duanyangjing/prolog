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


rbt_min(n(Val, null, null), Val).
rbt_min(n(_, L, _), X) :- rbt_min(L, X).

% delete leaf or node with less <= 1 children, result is always black.
%
% double black null
delete(n(i, _, e, e), i, n(null, bb, e, e)).
% if i is red, then child must be black, result is black.
% if i is black, since one child is null, the other child must be red, result is black.
% so no matter i's color, result is always black.
delete(n(i, _, n(li, _, e, e), e), i, n(li, blk, e, e)).
delete(n(i, _, e, n(ri, _, e, e)), i, n(ri, blk, e, e)).

% delete node with with 2 non-null children, replace with inorder succ,
% and delete inorder succ from right subtree. Need to fix inbalance!
delete(n(i, color, L, R), i, T) :- 
	rbt_min(R, X), delete(R, X, Rx), fix(n(X, color, L, Rx), T).

fix(n(X, bb, L, R), n(X, b, L, R)).
fix(n())



