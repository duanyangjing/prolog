type term =
	| Const of int
	| Const of string
	| List of term list
	| Var of string
	| Compterm of string * term list

type query = string * term list

(*
Handling a query: build the heap and set arg registers
    fun query_args2instr args:
    for each arg in args
        case arg of
            var: if first time occur then put_variable VR,AR
                 else set_value VR
            const: put_constant c,AR
            list([H|T]): query_processList [H|T]
            structure: put_structure f,AR

Consider tail as an additional variable, assign a var reg for it.
    fun query_processList [H|T]: TODO: how is list represented in heap?
    put_list AR
    case H of
        var: if first time occur then put_variable VR,AR
             else set_value VR
        const: set_constant c
        structure: TODO:

--------------------------------------------------------------------------------
Handling a fact: use arg reg to get data from heap and unify with fact definition
fun fact_args2instr args:
for each arg in args:
    case arg of
        var: if first time occur then get_variable VR,AR
             else get_value VR,AR
        const: get_constant c,AR
        list: get_list AR
        structure(f, L):
            get_structure f,AR
            for each term in L:
                case term of
                    var: if first time occur then unify_variable VR
                         else unify_value VR
                    const: unify_constant c
                    list: TODO
                    structure: get_structure f,AR

fun fact_processList [H|T]:

case H of


--------------------------------------------------------------------------------
Handling a rule: reset arg reg and build heap for each subgoal, call them in
sequence

allocate # of permanent variable stack space
get args of p0
put args of p1
call p1
...
put args of pn
call pn
deallocate


--------------------------------------------------------------------------------
handling alternative choices: add choice point in stack before each choice
try_me_else label of alternative 1:
{instr for alternative 0}
retry_me_else label of alternative 2:
{instr for alternative 1}
...
retry_me_else label of alternative k:
{instr for alternative k-1}
trust_me
{instr for last alternative}


*)

let compileQuery query instr =
    let args2instr terms =
