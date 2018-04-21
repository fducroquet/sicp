;; To define primitive operations for the ec-evaluator.
(define-macro (ecop op)
              `(list ',op ,op))

(define eceval-operations
  (list
    ;; Primitive Scheme operations.
    (ecop read)
    (ecop list)
    (ecop eq?)
    (ecop string-append)
    (ecop object->string)
    (ecop length)
    (ecop cons)
    (ecop reverse)

    ;; Syntax operations
    (ecop self-evaluating?)
    (ecop quoted?)
    (ecop text-of-quotation)
    (ecop variable?)
    (ecop assignment?)
    (ecop assignment-variable)
    (ecop assignment-value)
    (ecop definition?)
    (ecop definition-variable)
    (ecop definition-value)
    (ecop lambda?)
    (ecop lambda-parameters)
    (ecop lambda-body)
    (ecop if?)
    (ecop if-predicate)
    (ecop if-consequent)
    (ecop if-alternative)
    (ecop begin?)
    (ecop begin-actions)
    (ecop last-exp?)
    (ecop first-exp)
    (ecop rest-exps)
    (ecop application?)
    (ecop operator)
    (ecop operands)
    (ecop no-operands?)
    (ecop first-operand)
    (ecop rest-operands)
    (ecop cond?)
    (ecop and?)
    (ecop or?)
    (ecop let?)
    (ecop let*?)
    (ecop letrec?)
    (ecop while?)
    (ecop until?)
    (ecop for?)
    (ecop cond-clauses)
    (ecop cond-else-clause?)
    (ecop cond-predicate)
    (ecop cond-actions)
    (ecop no-more-clauses?)
    (ecop first-clause)
    (ecop rest-clauses)
    (ecop last-clause?)

    ; Syntax transformation procedures
    (ecop cond->if)
    (ecop and->if)
    (ecop or->if)
    (ecop let->combination)
    (ecop let*->nested-lets)
    (ecop letrec->let)
    (ecop while->if)
    (ecop until->while)
    (ecop for->let)

    ;; Other operations
    (ecop true?)
    (ecop false?)
    (ecop make-procedure)
    (ecop compound-procedure?)
    (ecop procedure-parameters)
    (ecop procedure-body)
    (ecop procedure-environment)
    (ecop compiled-procedure?)
    (ecop compiled-procedure-entry)
    (ecop compiled-procedure-env)
    (ecop make-compiled-procedure)
    (ecop extend-environment)
    (ecop lookup-variable-value)
    (ecop set-variable-value!)
    (ecop define-variable!)
    (ecop primitive-procedure?)
    (ecop apply-primitive-procedure)
    (ecop check-primitive-arguments)
    (ecop prompt-for-input)
    (ecop announce-output)
    (ecop user-print)
    (ecop empty-arglist)
    (ecop adjoin-arg)
    (ecop last-operand?)
    (ecop no-more-exps?)
    (ecop get-global-environment)))

(define eceval
  (make-machine
    '(exp env val proc argl continue unev)
    eceval-operations
    `(;; 5.4.4 Running the Evaluator
        (branch (label external-entry))
    read-eval-print-loop
        (perform (op initialize-stack))
        (perform (op prompt-for-input) (const ";;; EC-Eval input:"))
        (assign exp (op read))
        (assign env (op get-global-environment))
        (assign continue (label print-result))
        (goto (label eval-dispatch))
    print-result
        (perform (op print-stack-statistics))
        (perform (op announce-output) (const ";;; EC-Eval value:"))
        (perform (op user-print) (reg val))
        (goto (label read-eval-print-loop))

    external-entry
        (perform (op initialize-stack))
        (assign env (op get-global-environment))
        (assign continue (label print-result))
        (goto (reg val))

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
        (test (op eq?) (reg val) (const ,err-unbound-var))
        (branch (label err-lookup-unbound-var))
        (goto (reg continue))
    err-lookup-unbound-var
        (assign unev (op object->string) (reg exp))
        (assign val (op string-append)
                (const "Error: accessing unbound variable: ")
                (reg unev))
        (goto (label signal-error))
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
        (assign unev (op operands) (reg exp))
        (assign exp (op operator) (reg exp))
        (test (op variable?) (reg exp))
        (branch (label symbol-operator))
        (save env)
        (save unev)
        (assign continue (label ev-appl-did-operator))
        (goto (label eval-dispatch))
    symbol-operator
        (assign continue (label ev-appl-did-symbol-operator))
        (goto (label ev-variable))
    ev-appl-did-operator
        (restore unev)          ; the operands
        (restore env)
    ev-appl-did-symbol-operator
        (assign argl (op empty-arglist))
        (assign proc (reg val)) ; the operator
        (test (op no-operands?) (reg unev))
        (branch (label apply-dispatch))
        (save proc)
    ev-appl-operand-loop
        (save argl)
        (assign exp (op first-operand) (reg unev))
        (test (op last-operand?) (reg unev))
        (branch (label ev-appl-last-arg))
        (save env)
        (save unev)
        (assign continue (label ev-appl-accumulate-arg))
        (goto (label eval-dispatch))
    ev-appl-accumulate-arg
        (restore unev)
        (restore env)
        (restore argl)
        (assign argl (op adjoin-arg) (reg val) (reg argl))
        (assign unev (op rest-operands) (reg unev))
        (goto (label ev-appl-operand-loop))
    ev-appl-last-arg
        (assign continue (label ev-appl-accum-last-arg))
        (goto (label eval-dispatch))
    ev-appl-accum-last-arg
        (restore argl)
        (assign argl (op adjoin-arg) (reg val) (reg argl))
        (restore proc)
        (goto (label apply-dispatch))

    ;; Procedure application
    apply-dispatch
        (test (op primitive-procedure?) (reg proc))
        (branch (label primitive-apply))
        (test (op compound-procedure?) (reg proc))
        (branch (label compound-apply))
        (test (op compiled-procedure?) (reg proc))
        (branch (label compiled-apply))
        (goto (label unknown-procedure-type))
    primitive-apply
        (assign val (op check-primitive-arguments) (reg proc) (reg argl))
        (test (op eq?) (reg val) (const #t))
        (branch (label primitive-apply-1))
        (assign unev (op object->string) (reg argl))
        (assign val (op string-append) (const "Error in primitive procedure application: ")
                (reg val) (const "\nArguments: ") (reg unev))
        (goto (label signal-error))
    primitive-apply-1
        (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
        (restore continue)
        (goto (reg continue))
    compound-apply
        (assign unev (op procedure-parameters) (reg proc))
        (assign env (op procedure-environment) (reg proc))
        (assign env (op extend-environment) (reg unev) (reg argl) (reg env))
        (test (op eq?) (reg env) (const ,err-arity))
        (branch (label arity-error))
        (assign unev (op procedure-body) (reg proc))
        (goto (label ev-sequence))
    arity-error
        (assign unev (op length) (reg unev))
        (assign unev (op object->string) (reg unev))
        (assign argl (op length) (reg argl))
        (assign argl (op object->string) (reg argl))
        (assign val (op string-append)
                (const "Error in procedure applicatio: wrong number of arguments, expected ")
                (reg unev) (const ", got ") (reg argl))
        (goto (label signal-error))
    compiled-apply
        (restore continue)
        (assign val (op compiled-procedure-entry) (reg proc))
        (goto (reg val))

    ;; 5.4.2 Sequence Evaluation and Tail Recursion
    ev-begin
        (assign unev (op begin-actions) (reg exp))
        (save continue)
        (goto (label ev-sequence))
    ev-sequence
        ; Uncomment the 2 following lines for the non tail-recursive evaluator.
        ; (test (op no-more-exps?) (reg unev))
        ; (branch (label ev-sequence-end))
        (assign exp (op first-exp) (reg unev))
        ; Comment out the 2 following lines for the non tail-recursive evaluator.
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
    ev-sequence-end
        (restore continue)
        (goto (reg continue))

    ;; 5.4.3 Conditionals, Assignments, and Definitions
    ;; Conditionals
    ev-if
        (save exp)      ; Save expression for later.
        (save env)
        (save continue)
        (assign continue (label ev-if-decide))
        (assign exp (op if-predicate) (reg exp))
        ; Evaluate the predicate:
        (goto (label eval-dispatch))
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
        (assign val (op set-variable-value!) (reg unev) (reg val) (reg env))
        (test (op eq?) (reg val) (const ,err-unbound-var))
        (branch (label err-set-unbound-var))
        (assign val (const ok))
        (goto (reg continue))
    err-set-unbound-var
        (assign unev (op object->string) (reg unev))
        (assign val (op string-append)
                (const "Error: setting unbound variable: ")
                (reg unev))
        (goto (label signal-error))

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
        (assign val (const "Error: the else clause must be the last clause."))
        (goto (label signal-error)))))
