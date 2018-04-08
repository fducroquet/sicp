ev-cond
    (assign unev (op cond-clauses) (reg exp))
ev-cond-clauses
    ; unev contains the remaining clauses.
    (test (op no-more-clauses?) (reg unev))
    (branch (label no-clause-found))
    (assign exp (op first-clause) (reg unev))
    (test (op cond-else-clause?) (reg exp))
    (branch (label else-clause))
    (save unev)
    (save env)
    ; Save exp so we can retrieve the actions if the predicate is true.
    (save exp)
    (assign exp (op cond-predicate) (reg exp))
    (save continue)
    (assign continue (label cond-clause-pred-evaluated))
    (goto (label eval-dispatch))
cond-clause-pred-evaluated
    (restore continue)
    (restore exp)
    (restore env)
    (restore unev)
    (test (op true?) (reg val))
    ; Success, evaluate the actions of the clause.
    (branch (label true-pred-found))
    ; Go to next clause.
    (assign unev (op rest-clauses) (reg unev))
    (goto (label ev-cond-clauses))
else-clause
    (test (op last-clause?) (reg unev))
    (branch (label true-pred-found))
    (goto (label else-not-last))
true-pred-found
    (assign unev (op cond-actions) (reg exp))
    (save continue)
    (goto (label ev-sequence))
no-clause-found
    (assign val (const false))
    (goto (reg continue))
else-not-last
    (assign val (const else-not-last-clause))
    (goto (label signal-error))
