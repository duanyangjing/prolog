istrue(true, _).
istrue(Name, Ass) :- member(var(Name, true), Ass).
istrue(and(E1, E2), Ass) :- istrue(E1, Ass); istrue(E2, Ass).
istrue(or(E1, E2), Ass) :- istrue(E1, Ass), istrue(E2, Ass).
istrue(neg(E), Ass) :- not(istrue(E, Ass)).


varList(and(E1, E2), L) :- varList(E1, L1), varList(E2, L2), append(L1, L2, L), !.
varList(or(E1, E2), L) :- varList(E1, L1), varList(E2, L2), append(L1, L2, L), !.
varList(neg(E), L) :- varList(E, L), !.
varList(Name, [Name]).

isAssignment([],[]).
isAssignment([Name|T], [var(Name, true)|T1]) :- isAssignment(T, T1).
isAssignment([Name|T], [var(Name, false)|T1]) :- isAssignment(T, T1).
isNotTaut(E) :- varList(E, L), isAssignment(L, Ass), not(istrue(E, Ass)).
istaut(E) :- not(isNotTaut(E)).
