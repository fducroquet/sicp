(define lazy-eceval-operations
  (append eceval-operations (list
    ;; Operations used only in lazy evaluator.
    (ecop cdr)
    (ecop set-car!)
    (ecop set-cdr!)
    (ecop delay-it)
    (ecop thunk?)
    (ecop thunk-exp)
    (ecop thunk-env)
    (ecop evaluated-thunk?)
    (ecop thunk-value))))

(define lazy-eceval
  (make-machine
    '(exp env val proc argl continue unev)
    lazy-eceval-operations
    '(;; 5.4.4 Running the Evaluator
    read-eval-print-loop
        (perform (op initialize-stack))
        (perform (op prompt-for-input) (const ";;; EC-Eval input:"))
        (assign exp (op read))
        (assign env (op get-global-environment))
        (assign continue (label print-result))
        (goto (label actual-value))
    print-result
        (perform (op announce-output) (const ";;; EC-Eval value:"))
        (perform (op user-print) (reg val))
        (goto (label read-eval-print-loop))

    unknown-expression-type
        (assign val (const unknown-expression-type-error))
        (goto (label signal-error))
    unknown-procedure-type
        ; Clean up stack (from apply-dispatch)
        (restore continue)
        (assign val (const unknown-procedure-type-error))
        (goto (label signal-error))
    signal-error
        (perform (op user-print) (reg val))
        (goto (label read-eval-print-loop))

    ;; 5.4.1 The Core of the Explicit-Control Evaluator
    eval-dispatch
        (test (op self-evaluating?) (reg exp))
        (branch (label ev-self-eval))
        (test (op variable?) (reg exp))
        (branch (label ev-variable))
        (test (op quoted?) (reg exp))
        (branch (label ev-quoted))
        (test (op assignment?) (reg exp))
        (branch (label ev-assignment))
        (test (op definition?) (reg exp))
        (branch (label ev-definition))
        (test (op if?) (reg exp))
        (branch (label ev-if))
        (test (op cond?) (reg exp))
        (branch (label ev-cond))
        (test (op and?) (reg exp))
        (branch (label ev-and))
        (test (op or?) (reg exp))
        (branch (label ev-or))
        (test (op let?) (reg exp))
        (branch (label ev-let))
        (test (op let*?) (reg exp))
        (branch (label ev-let*))
        (test (op letrec?) (reg exp))
        (branch (label ev-letrec))
        (test (op while?) (reg exp))
        (branch (label ev-while))
        (test (op until?) (reg exp))
        (branch (label ev-until))
        (test (op for?) (reg exp))
        (branch (label ev-for))
        (test (op lambda?) (reg exp))
        (branch (label ev-lambda))
        (test (op begin?) (reg exp))
        (branch (label ev-begin))
        (test (op application?) (reg exp))
        (branch (label ev-application))
        (goto (label unknown-expression-type))

    ;; Evaluating simple expressions
    ev-self-eval
        (assign val (reg exp))
        (goto (reg continue))
    ev-variable
        (assign val
                (op lookup-variable-value)
                (reg exp)
                (reg env))
        (goto (reg continue))
    ev-quoted
        (assign val (op text-of-quotation) (reg exp))
        (goto (reg continue))
    ev-lambda
        (assign unev (op lambda-parameters) (reg exp))
        (assign exp (op lambda-body) (reg exp))
        (assign val (op make-procedure) (reg unev) (reg exp) (reg env))
        (goto (reg continue))

    ;; Evaluating procedure applications
    ev-application
        (save continue)
        (save env)
        (assign unev (op operands) (reg exp))
        (save unev)
        (assign exp (op operator) (reg exp))
        (assign continue (label ev-appl-did-operator))
        (goto (label actual-value))
    ev-appl-did-operator
        (restore unev)          ; the operands
        (restore env)
        (assign proc (reg val)) ; the operator
        (goto (label apply-dispatch))

    ;; Procedure application
    apply-dispatch
        ; Actual value of procedure to apply in proc, operand expressions in 
        ; unev, environment in env.
        (assign argl (op empty-arglist))
        (test (op primitive-procedure?) (reg proc))
        (branch (label primitive-apply))
        (test (op compound-procedure?) (reg proc))
        (branch (label compound-apply))
        (goto (label unknown-procedure-type))
    primitive-apply
        ; Accumulate actual values of arguments in argl.
        (save proc)
        (test (op no-operands?) (reg unev))
        (branch (label actual-primitive-apply))
    ev-appl-operand-loop
        (save argl)
        (assign exp (op first-operand) (reg unev))
        (test (op last-operand?) (reg unev))
        (branch (label ev-appl-last-arg))
        (save env)
        (save unev)
        (assign continue (label ev-appl-accumulate-arg))
        (goto (label actual-value))
    ev-appl-accumulate-arg
        (restore unev)
        (restore env)
        (restore argl)
        (assign argl (op adjoin-arg) (reg val) (reg argl))
        (assign unev (op rest-operands) (reg unev))
        (goto (label ev-appl-operand-loop))
    ev-appl-last-arg
        (assign continue (label ev-appl-accum-last-arg))
        (goto (label actual-value))
    ev-appl-accum-last-arg
        (restore argl)
        (assign argl (op adjoin-arg) (reg val) (reg argl))
    actual-primitive-apply
        (restore proc)
        (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
        (restore continue)
        (goto (reg continue))

    compound-apply
        ; Accumulate delayed arguments in argl.
        (test (op no-operands?) (reg unev))
        (branch (label actual-compound-apply))
        (assign exp (op first-operand) (reg unev))
        (assign exp (op delay-it) (reg exp) (reg env))
        (assign argl (op adjoin-arg) (reg exp) (reg argl))
        (assign unev (op rest-operands) (reg unev))
        (goto (label compound-apply))
    actual-compound-apply
        (assign unev (op procedure-parameters) (reg proc))
        (assign env (op procedure-environment) (reg proc))
        (assign env (op extend-environment) (reg unev) (reg argl) (reg env))
        (assign unev (op procedure-body) (reg proc))
        (goto (label ev-sequence))

    ;; 5.4.2 Sequence Evaluation and Tail Recursion
    ev-begin
        (assign unev (op begin-actions) (reg exp))
        (save continue)
        (goto (label ev-sequence))
    ev-sequence
        (assign exp (op first-exp) (reg unev))
        (test (op last-exp?) (reg unev))
        (branch (label ev-sequence-last-exp))
        (save unev)
        (save env)
        (assign continue (label ev-sequence-continue))
        (goto (label eval-dispatch))
    ev-sequence-continue
        (restore env)
        (restore unev)
        (assign unev (op rest-exps) (reg unev))
        (goto (label ev-sequence))
    ev-sequence-last-exp
        (restore continue)
        (goto (label eval-dispatch))

    ;; 5.4.3 Conditionals, Assignments, and Definitions
    ;; Conditionals
    ev-if
        (save exp)      ; Save expression for later.
        (save env)
        (save continue)
        (assign continue (label ev-if-decide))
        (assign exp (op if-predicate) (reg exp))
        ; Evaluate the predicate:
        (goto (label actual-value))
    ev-if-decide
        (restore continue)
        (restore env)
        (restore exp)
        (test (op true?) (reg val))
        (branch (label ev-if-consequent))
    ev-if-alternative
        (assign exp (op if-alternative) (reg exp))
        (goto (label eval-dispatch))
    ev-if-consequent
        (assign exp (op if-consequent) (reg exp))
        (goto (label eval-dispatch))

    ;; Assignments and definitions
    ev-assignment
        (assign unev (op assignment-variable) (reg exp))
        (save unev)     ; Save variable for later.
        (assign exp (op assignment-value) (reg exp))
        (save env)
        (save continue)
        (assign continue (label ev-assignment-1))
        ; Evaluate the assignment value:
        (goto (label eval-dispatch))
    ev-assignment-1
        (restore continue)
        (restore env)
        (restore unev)
        (perform (op set-variable-value!) (reg unev) (reg val) (reg env))
        (assign val (const ok))
        (goto (reg continue))

    ev-definition
        (assign unev (op definition-variable) (reg exp))
        (save unev)     ; Save variable for later.
        (assign exp (op definition-value) (reg exp))
        (save env)
        (save continue)
        (assign continue (label ev-definition-1))
        ; Evaluate the definition value:
        (goto (label eval-dispatch))
    ev-definition-1
        (restore continue)
        (restore env)
        (restore unev)
        (perform (op define-variable!) (reg unev) (reg val) (reg env))
        (assign val (const ok))
        (goto (reg continue))

    ;; Exercise 5.23: Derived expressions
    ; ev-cond
    ;     (assign exp (op cond->if) (reg exp))
    ;     (goto (label eval-dispatch))
    ev-and
        (assign exp (op and->if) (reg exp))
        (goto (label eval-dispatch))
    ev-or
        (assign exp (op or->if) (reg exp))
        (goto (label eval-dispatch))
    ev-let
        (assign exp (op let->combination) (reg exp))
        (goto (label eval-dispatch))
    ev-let*
        (assign exp (op let*->nested-lets) (reg exp))
        (goto (label eval-dispatch))
    ev-letrec
        (assign exp (op letrec->let) (reg exp))
        (goto (label eval-dispatch))
    ev-while
        (assign exp (op while->if) (reg exp))
        (goto (label eval-dispatch))
    ev-until
        (assign exp (op until->while) (reg exp))
        (goto (label eval-dispatch))
    ev-for
        (assign exp (op for->let) (reg exp))
        (goto (label eval-dispatch))

    ; Exercise 5.24: Cond as a basic special form.
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

    actual-value
        (save continue)
        (assign continue (label force-it))
        (goto (label eval-dispatch))
    force-it
        ;; Forces value of reg val.
        ; Saved at actual-value
        (restore continue)
        (test (op thunk?) (reg val))
        (branch (label force-thunk))
        (test (op evaluated-thunk?) (reg val))
        (branch (label force-evaluated-thunk))
        (goto (reg continue))
    force-thunk
        (assign env (op thunk-env) (reg val))
        (assign exp (op thunk-exp) (reg val))
        ; Comment out the following 3 lines to use unmemoized force-it.
        (save val) ; Save thunk to set its value later.
        (save continue)
        (assign continue (label thunk-result-forced))
        (goto (label actual-value))
    thunk-result-forced
        ; val contains the actual value.
        (assign exp (reg val))
        (restore continue)
        (restore val) ; Thunk
        (perform (op set-car!) (reg val) (const evaluated-thunk))
        (assign unev (op cdr) (reg val))
        (perform (op set-car!) (reg unev) (reg exp))
        (perform (op set-cdr!) (reg unev) (const ()))
        (assign val (reg exp))
        (goto (reg continue))
    force-evaluated-thunk
        (assign val (op thunk-value) (reg val))
        (goto (reg continue)))))
