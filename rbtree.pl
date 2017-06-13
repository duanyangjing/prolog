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

% del leaf or node with less <= 1 children, result is always black.
%
% double black null
del_root(n(Val, _, e, e), Val, e).

% if Val is red, then child must be black, result is black.
% if Val is black, since one child is null, the other child must be red, result is black.
% so no matter Val's color, result is always black.
del_root(n(Val, _, n(li, _, e, e), e), Val, n(li, blk, e, e)).
del_root(n(Val, _, e, n(ri, _, e, e)), Val, n(ri, blk, e, e)).

% del node with with 2 non-null children, replace with inorder succ,
% and del inorder succ from right subtree. Need to fix inbalance!
del_root(n(Val, Color, L, R), Val, T) :- 
	rbt_min(R, X), delete(R, X, Rx), fix(n(X, Color, L, Rx), T).

black(e).
black(n(_, blk, _, _)).
% fix(n(X, bb, L, R), n(X, b, L, R)).
% case 1 CLRS P329, A,C,E could be null, as long as colored black
fix(n(B, blk, A, n(D, red, C, E)), n(D, blk, n(B, red, A, C), E)) :- 
	black(A), black(C), black(E),!.

% case 2 CLRS P329, A,C,E could be null, as long as colored black
fix(n(B, _, A, n(D, blk, C, E)), n(B, blk, A, n(D, red, C, E))) :- 
	black(A), black(C), black(E),!.

% case 3 CLRS P329, A,E could be null
fix(n(B, Color, A, n(D, blk, n(C, red, CL, CR), E)),
	n(C, Color, n(B, blk, A, CL), n(D, blk, CR, E))) :- 
	black(A), black(E),!.

% case 4 CLRS P329, A,C could be null, C color doesn't matter
fix(n(B, Color, A, n(D, blk, C, n(E, red, EL, ER))),
	n(D, Color, n(B, blk, A, C), n(E, blk, EL, ER))) :- black(A),!.
fix(T, T).

% general delete
delete(n(Val, Color, L, R), Val, T) :-
	del_root(n(Val, Color, L, R), Val, T).
delete(n(Val, Color, L, R), X, T) :- 
	X < Val, delete(L, X, Lx), fix(n(Val, Color, Lx, R), T).
delete(n(Val, Color, L, R), X, T) :-
	X > Val, delete(R, X, Rx), fix(n(Val, Color, L, Rx), T).
