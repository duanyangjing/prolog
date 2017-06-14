member(X, [H|T]) :- X=H; member(X, T).
subseq(_, []).
subseq([H|T1], [H|T2]) :- subseq(T1, T2).
subseq([H1|T1], [H2|T2]) :- H1<H2, subseq(T1, [H2|T2]).


union([],S,S).
union(S,[],S).
% first elements are the same, just union rest
union([X|Xs],[X|Ys],[X|Zs]):-union(Xs,Ys,Zs).
% first elements not the same, has to be one of them
union([X|Xs],[Y|Ys],[X|Zs]):-X<Y,union(Xs,[Y|Ys],Zs).
union([X|Xs],[Y|Ys],[Y|Zs]):-Y<X,union([X|Xs],Ys,Zs).

diff(S, [], S).
% not condition is useful to make the first two rules disjoint, otherwise
% there will be duplicate result when searching.
diff([], S, []) :- not(S=[]).
diff([X|Xs], [X|Ys], Z) :- diff(Xs, Ys, Z).
diff([X|Xs], [Y|Ys], [X|Zs]) :- X<Y, diff(Xs, [Y|Ys], Zs).
diff([X|Xs], [Y|Ys], Z) :- Y<X, diff([X|Xs], Ys, Z).

select([H|T], H, T). % selecting from head
select([H|T], X, [H|L]) :- select(T, X, L). % selecting from tail 

permute([], []).
permute(L, [H|T]) :- select(L, H, X), permute(X, T).

% append is O(n) complexity,  building up solution after recursion.
append([], L, L).
append([H|T1], L, [H|T2]) :- append(T1, L, T2).

% This traditional approach needs the call stack of every recursive call, because
% previous call results depend on next recursive calls.
%
% Each element will triger an append call, which is O(n), total complexity is
% O(n^2). For each append call, some computation are carried out and then wasted.
% For example, rev([1,2,3],_) will call append(_,_,[1,2,3]), and itself will call 
% append(_,_,[1,2]), but
% this same call will be trigered when for rev([1,2],_) too, which is duplicated.
rev([],[]).
rev([H|T], L) :- rev(T, X), append(X, [H], L).

% This is tail recursion using accumulator (A). A is accumulated as we traverse
% the list. Each time the head of L is concated with Asofar, which will be the 
% reverse eventually (when we hit the base case L is empty, A is reverse).
%
% This takes O(n) time.
accRev([], A, A).
accRev([H|T], A, R) :- accRev(T, [H|A], R).
betterRev(L, R) :- accRev(L, [], R).

% similar example on list length. First use traditional recursion.
% This takes O(n) time like append.
listlen([], 0).
listlen([_|T], N) :- listlen(T, N1), N is N1 + 1.

% using tail recurision and accumulator.
% len(L) + A = N
% This takes \Theta(n) time.
acclen([], A, A).
acclen([_|T], A, N) :- A1 is A + 1, acclen(T, A1, N).
betterlen(L, N) :- acclen(L, 0, N).


% list is empty, then sum is 0 and result is empty
% think about the inductive structure of a list, base case should be empty
subset_sum(0, [], []). 
% use head to build result, then Sum must be >= H
subset_sum(Sum, [H|T], [H|L]) :- Sum >= H, NSum is Sum-H, subset_sum(NSum, T, L).
% doesn't use head to build result
subset_sum(Sum, [_|T], L) :- subset_sum(Sum, T, L).
