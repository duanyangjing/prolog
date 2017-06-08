% null is a binary  tree
% a single Val is a binary tree.
% Val has one child, which is the Val of a binary tree.
% Val has two children. Each child is the Val of a binary tree.
binaryTree(null).
binaryTree(n(_, L, R)) :- binaryTree(L), binaryTree(R).

find(n(Val, _, _), Val).
find(n(Val, L, R), X) :- X < Val, find(L, X).
find(n(Val, L, R), X) :- X > Val, find(R, X).

% root, L, R
preorder(n(Val, null, null), [Val]).
preorder(n(Root, L, R), [Root|Res]) :- preorder(L, LWalk), preorder(R, RWalk), append(LWalk, RWalk, Res).
% L, root, R
inorder(n(Val, null, null), [Val]).
inorder(n(Root, L, R), X) :- inorder(L, LWalk), inorder(R, RWalk), append(LWalk, [Root|RWalk], X).
% L, R, root
postorder(n(Val, null, null), [Val]).
postorder(n(Root, L, R), X) :- postorder(L, LWalk), postorder(R, RWalk), append(LWalk, RWalk, Res), append(Res, [Root], X).

sorted([]).
sorted([_]).
sorted([H1|[H2|T]]) :- H1=<H2, sorted([H2|T]).

bst(null).
bst(n(Val, null, null)) :- not(Val=null).
bst(n(Val, L, R)) :- inorder(n(Val, L, R), X), sorted(X).

bstFind(n(Val, _, _), Val).
bstFind(n(Val, _, R), X) :- X > Val, find(R, X).
bstFind(n(Val, L, _), X) :- X < Val, find(L, X).

bstInsert(null, X, n(X, null, null)).
bstInsert(n(Val, L, R), X, n(Val, L1, R)) :- X =< Val, bstInsert(L, X, L1).
bstInsert(n(Val, L, R), X, n(Val, L, R1)) :- X > Val, bstInsert(R, X, R1).


treemin(n(Val, null, null), Val).
treemin(n(_, L, _), X) :- treemin(L, X).

del(n(Val, null, R), Val, R).
del(n(Val, L, null), Val, L) :- not(L=null).
% Y is the successor of Val, put Y as new root, and delete Y in the original
% subtree.
del(n(Val, L, R), Val, n(Y, L, Rx)) :- treemin(R, Y), del(R, Y, Rx).
del(n(Val, L, R), X, n(Val, L, R1)) :- X > Val, del(R, X, R1).
del(n(Val, L, R), X, n(Val, L1, R)) :- X < Val, del(L, X, L1).