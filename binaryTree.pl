% a single Val is a binary tree.
% Val has one child, which is the Val of a binary tree.
% Val has two children. Each child is the Val of a binary tree.

node(3, 2, 5).
node(2, 4, null).
node(5, 7, null).
node(4, null, null).
node(7, null, null).
val(node(Val, _, _), Val).

% null is a binary  tree
% a single Val is a binary tree.
% Val has one child, which is the Val of a binary tree.
% Val has two children. Each child is the Val of a binary tree.
binaryTree(null).
binaryTree(node(_, L, R)) :- binaryTree(L), binaryTree(R).

find(node(Val, _, _), Val).
find(node(Val, L, R), X) :- not(X = Val), (find(L, X); find(R, X)).

% root, L, R
preorder(node(Val, null, null), [Val]).
preorder(node(Root, L, R), [Root|Res]) :- preorder(L, LWalk), preorder(R, RWalk), append(LWalk, RWalk, Res).
% L, root, R
inorder(node(Val, null, null), [Val]).
inorder(node(Root, L, R), X) :- inorder(L, LWalk), inorder(R, RWalk), append(LWalk, [Root|RWalk], X).
% L, R, root
postorder(node(Val, null, null), [Val]).
postorder(node(Root, L, R), X) :- postorder(L, LWalk), postorder(R, RWalk), append(LWalk, RWalk, Res), append(Res, [Root], X).

sorted([]).
sorted([_]).
sorted([H1|[H2|T]]) :- H1=<H2, sorted([H2|T]).

bst(null).
bst(node(Val, null, null)) :- not(Val=null).
bst(node(Val, L, R)) :- inorder(node(Val, L, R), X), sorted(X).

bstFind(node(Val, _, _), Val).
bstFind(node(Val, _, R), X) :- X > Val, find(R, X).
bstFind(node(Val, L, _), X) :- X < Val, find(L, X).

bstInsert(null, X, node(X, null, null)).
bstInsert(node(Val, L, R), X, node(Val, L1, R)) :- X =< Val, bstInsert(L, X, L1).
bstInsert(node(Val, L, R), X, node(Val, L, R1)) :- X > Val, bstInsert(R, X, R1).

% delete a node with left null, replace itself with right subtree
bstDel(node(Val, null, R), Val, R).
% delete a node with right null, replace itself with left subtree
bstDel(node(Val, L, null), Val, L) :- not(L = null).
% case c CLRS P297
bstDel(node(Val, L, node(Rval, null, Rright)), Val, node(Rval, L, Rright)).
% case d CLRS P297
bstDel(node(Val, L, node(Rval, node(Y, null, X), RR)),
	Val, node(Y, L, node(Rval, X, RR))).
% general del
bstDel(node(Val, L, R), X, node(Val, L, R1)) :- X > Val, bstDel(R, X, R1).
bstDel(node(Val, L, R), X, node(Val, L1, R)) :- X < Val, bstDel(L, X, L1).












