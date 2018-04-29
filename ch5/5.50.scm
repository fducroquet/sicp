(compile-and-go
  '(begin
     (define apply-in-underlying-scheme apply)

     (define (map f l)
       (if (null? l)
         l
         (cons (f (car l)) (map f (cdr l)))))

     ; For letrec->let.
     (define (map-two f l1 l2)
       (if (null? l1)
         '()
         (cons (f (car l1) (car l2))
               (map-two f (cdr l1) (cdr l2)))))

     ;; Section 4.1.1: The Core of the Evaluator
     (define (eval exp env)
       (cond ((self-evaluating? exp) exp)
             ((variable? exp) (lookup-variable-value exp env))
             ((quoted? exp) (text-of-quotation exp))
             ((assignment? exp) (eval-assignment exp env))
             ((definition? exp) (eval-definition exp env))
             ((if? exp) (eval-if exp env))
             ((or? exp) (eval-or exp env))
             ((and? exp) (eval-and exp env))
             ((lambda? exp)
              (make-procedure (lambda-parameters exp)
                              (lambda-body exp)
                              env))
             ((let? exp) (eval (let->combination exp) env))
             ((let*? exp) (eval (let*->nested-lets exp) env))
             ((letrec? exp) (eval (letrec->let exp) env))
             ((begin? exp)
              (eval-sequence (begin-actions exp) env))
             ((cond? exp) (eval (cond->if exp) env))
             ((application? exp)
              (apply (eval (operator exp) env)
                     (list-of-values (operands exp) env)))
             (else
               (error "Unknown expression type -- EVAL" exp))))

     (define (apply procedure arguments)
       (cond ((primitive-procedure? procedure)
              (apply-primitive-procedure procedure arguments))
             ((compound-procedure? procedure)
              (eval-sequence
                (procedure-body procedure)
                (extend-environment
                  (procedure-parameters procedure)
                  arguments
                  (procedure-environment procedure))))
             (else
               (error
                 "Unknown procedure type -- APPLY" procedure))))

     (define (list-of-values exps env)
       (if (no-operands? exps)
         '()
         (cons (eval (first-operand exps) env)
               (list-of-values (rest-operands exps) env))))

     (define (eval-if exp env)
       (if (true? (eval (if-predicate exp) env))
         (eval (if-consequent exp) env)
         (eval (if-alternative exp) env)))

     (define (eval-sequence exps env)
       (cond ((last-exp? exps) (eval (first-exp exps) env))
             (else (eval (first-exp exps) env)
                   (eval-sequence (rest-exps exps) env))))

     (define (eval-assignment exp env)
       (set-variable-value! (assignment-variable exp)
                            (eval (assignment-value exp) env)
                            env)
       'ok)

     (define (eval-definition exp env)
       (define-variable! (definition-variable exp)
                         (eval (definition-value exp) env)
                         env)
       'ok)

     ;; Section 4.1.2: Representing Expressions
     ; Self-evaluating
     (define (self-evaluating? exp)
       (cond ((number? exp) true)
             ((string? exp) true)
             (else false)))

     ; Variables
     (define (variable? exp) (symbol? exp))

     ; Quotations
     (define (quoted? exp)
       (tagged-list? exp 'quote))

     (define (text-of-quotation exp) (cadr exp))

     (define (tagged-list? exp tag)
       (if (pair? exp)
         (eq? (car exp) tag)
         false))

     ; Assignments
     (define (assignment? exp)
       (tagged-list? exp 'set!))

     (define (assignment-variable exp) (cadr exp))

     (define (assignment-value exp) (caddr exp))

     (define (make-set! name value)
       (list 'set! name value))

     ; Definitions
     (define (definition? exp)
       (tagged-list? exp 'define))

     (define (definition-variable exp)
       (if (symbol? (cadr exp))
         (cadr exp)
         (caadr exp)))

     (define (definition-value exp)
       (if (symbol? (cadr exp))
         (caddr exp)
         (make-lambda (cdadr exp)
                      (cddr exp))))

     ; Lambda expressions
     (define (lambda? exp) (tagged-list? exp 'lambda))

     (define (lambda-parameters exp) (cadr exp))

     (define (lambda-body exp) (cddr exp))

     (define (make-lambda parameters body)
       (cons 'lambda (cons parameters body)))

     ; Conditionals
     (define (if? exp) (tagged-list? exp 'if))

     (define (if-predicate exp) (cadr exp))

     (define (if-consequent exp) (caddr exp))

     (define (if-alternative exp)
       (if (not (null? (cdddr exp)))
         (cadddr exp)
         'false))

     (define (make-if predicate consequent alternative)
       (list 'if predicate consequent alternative))

     ; Begin
     (define (begin? exp) (tagged-list? exp 'begin))

     (define (begin-actions exp) (cdr exp))

     (define (last-exp? seq) (null? (cdr seq)))

     (define (first-exp seq) (car seq))

     (define (rest-exps seq) (cdr seq))

     (define (sequence->exp seq)
       (cond ((null? seq) seq)
             ((last-exp? seq) (first-exp seq))
             (else (make-begin seq))))

     (define (make-begin seq) (cons 'begin seq))

     ; Procedure application
     (define (application? exp) (pair? exp))

     (define (operator exp) (car exp))

     (define (operands exp) (cdr exp))

     (define (no-operands? ops) (null? ops))

     (define (first-operand ops) (car ops))

     (define (rest-operands ops) (cdr ops))

     ; Cond
     (define (cond? exp) (tagged-list? exp 'cond))

     (define (cond-clauses exp) (cdr exp))

     (define (cond-else-clause? clause)
       (eq? (cond-predicate clause) 'else))

     (define (cond-predicate clause) (car clause))

     ; Additional cond syntax from exercise 4.5.
     (define (cond-=>-clause? clause)
       (eq? (cadr clause) '=>))

     (define (cond-recipient clause)
       (caddr clause))

     (define (cond-actions clause)
       (if (cond-=>-clause? clause)
         (list (list (cond-recipient clause)
                     (cond-predicate clause)))
         (cdr clause)))

     (define (cond->if exp)
       (expand-clauses (cond-clauses exp)))

     (define (expand-clauses clauses)
       (if (null? clauses)
         'false
         (let ((first (car clauses))
               (rest (cdr clauses)))
           (if (cond-else-clause? first)
             (if (null? rest)
               (sequence->exp (cond-actions first))
               (error "ELSE clause isn’t last -- COND->IF"
                      clauses))
             (make-if (cond-predicate first)
                      (sequence->exp (cond-actions first))
                      (expand-clauses rest))))))

     ; Exercise 4.4 and and or
     (define (and? exp)
       (tagged-list? exp 'and))

     (define (and-tests exp)
       (cdr exp))

     (define (eval-and exp env)
       (define (eval-exps exps)
         (let ((first (eval (car exps) env)))
           (if (true? first)
             (if (last-exp? exps)
               first
               (eval-exps (cdr exps)))
             false)))
       (let ((exps (and-tests exp)))
         (if (null? exps)
           true
           (eval-exps exps))))

     ; Or
     (define (or? exp)
       (tagged-list? exp 'or))

     (define (or-tests exp)
       (cdr exp))

     (define (eval-or exp env)
       (define (eval-exps exps)
         (if (null? exps)
           false
           (let ((first (eval (car exps) env)))
             (if (true? first)
               first
               (eval-exps (cdr exps))))))
       (let ((exps (or-tests exp)))
         (eval-exps exps)))

     ; Exercise 4.6: let expressions (parts redefined by 4.8 not included).
     (define (let? exp)
       (tagged-list? exp 'let))

     (define (let-vars exp) (map car (let-bindings exp)))
     (define (let-args exp) (map cadr (let-bindings exp)))

     ; Exercise 4.7: let* expressions.
     (define (let*? exp)
       (tagged-list? exp 'let*))

     (define (let*-bindings exp) (cadr exp))
     (define (let*-body exp) (cddr exp))

     (define (make-let bindings body)
       (list 'let bindings body))

     (define (let*->nested-lets exp)
       (define (make-nested-lets bindings body)
         (cond ((null? bindings)
                (sequence->exp body))
               (else
                 (make-let (list (car bindings))
                           (make-nested-lets (cdr bindings) body)))))
       (make-nested-lets (let*-bindings exp) (let*-body exp)))

     ; Exercise 4.8: named let.
     (define (named-let? exp) (variable? (cadr exp)))

     (define (let-name exp) (cadr exp))

     (define (let-bindings exp)
       (if (named-let? exp)
         (caddr exp)
         (cadr exp)))

     (define (let-body exp)
       (if (named-let? exp)
         (cdddr exp)
         (cddr exp)))

     (define (make-define name value)
       (list 'define name value))

     (define (let->combination exp)
       (let ((bindings (let-bindings exp)))
         (if (named-let? exp)
           (make-begin
             (list (make-define (cons (let-name exp) (let-vars exp))
                                (sequence->exp (let-body exp)))
                   (cons (let-name exp) (let-args exp))))
           (cons (make-lambda (let-vars exp)
                              (let-body exp))
                 (let-args exp)))))

     ; Exercise 4.20: letrec expressions.
     (define (letrec? exp)
       (tagged-list? exp 'letrec))

     (define (letrec-bindings exp)
       (cadr exp))

     (define (letrec-body exp)
       (cddr exp))

     (define (letrec->let exp)
       (let* ((bindings (letrec-bindings exp))
              (vars (map car bindings))
              (vals (map cadr bindings)))
         (if (null? vars)
           (letrec-body exp)
           (make-let (map (lambda (var)
                            (list var ''*unassigned*))
                          vars)
                     (sequence->exp
                       (append
                         (map-two (lambda (var val)
                                    (make-set! var val))
                                  vars
                                  vals)
                         (letrec-body exp)))))))

     ;; Section 4.1.3: Evaluator Data Structures
     ; Predicates
     (define (true? x)
       (not (eq? x false)))

     (define (false? x)
       (eq? x false))

     ; Procedures
     (define (make-procedure parameters body env)
       (list 'procedure parameters body env))

     (define (compound-procedure? p)
       (tagged-list? p 'procedure))

     (define (procedure-parameters p) (cadr p))

     (define (procedure-body p) (caddr p))

     (define (procedure-environment p) (cadddr p))

     ; Environments
     (define (enclosing-environment env) (cdr env))

     (define (first-frame env) (car env))

     (define the-empty-environment '())

     (define (make-frame variables values)
       (cons variables values))

     (define (frame-variables frame) (car frame))

     (define (frame-values frame) (cdr frame))

     (define (add-binding-to-frame! var val frame)
       (set-car! frame (cons var (car frame)))
       (set-cdr! frame (cons val (cdr frame))))

     (define (extend-environment vars vals base-env)
       (if (= (length vars) (length vals))
         (cons (make-frame vars vals) base-env)
         (if (< (length vars) (length vals))
           (error "Too many arguments supplied" vars vals)
           (error "Too few arguments supplied" vars vals))))

     (define (lookup-variable-value var env)
       (define (env-loop env)
         (define (scan vars vals)
           (cond ((null? vars)
                  (env-loop (enclosing-environment env)))
                 ((eq? var (car vars))
                  (car vals))
                 (else (scan (cdr vars) (cdr vals)))))
         (if (eq? env the-empty-environment)
           (error "Unbound variable" var)
           (let ((frame (first-frame env)))
             (scan (frame-variables frame)
                   (frame-values frame)))))
       (env-loop env))

     (define (set-variable-value! var val env)
       (define (env-loop env)
         (define (scan vars vals)
           (cond ((null? vars)
                  (env-loop (enclosing-environment env)))
                 ((eq? var (car vars))
                  (set-car! vals val))
                 (else (scan (cdr vars) (cdr vals)))))
         (if (eq? env the-empty-environment)
           (error "Unbound variable -- SET!" var)
           (let ((frame (first-frame env)))
             (scan (frame-variables frame)
                   (frame-values frame)))))
       (env-loop env))

     (define (define-variable! var val env)
       (let ((frame (first-frame env)))
         (define (scan vars vals)
           (cond ((null? vars)
                  (add-binding-to-frame! var val frame))
                 ((eq? var (car vars))
                  (set-car! vals val))
                 (else (scan (cdr vars) (cdr vals)))))
         (scan (frame-variables frame)
               (frame-values frame))))

     ;; Section 4.1.4: Running the Evaluator as a Program
     (define (setup-environment)
       (let ((initial-env
               (extend-environment (primitive-procedure-names)
                                   (primitive-procedure-objects)
                                   the-empty-environment)))
         (define-variable! 'true true initial-env)
         (define-variable! 'false false initial-env)
         initial-env))

     (define (primitive-procedure? proc)
       (tagged-list? proc 'primitive))

     (define (primitive-implementation proc) (cadr proc))

     (define primitive-procedures
       (list (list 'car car)
             (list 'cdr cdr)
             (list 'cadr cadr)
             (list 'cdar cdar)
             (list 'cddr cddr)
             (list 'caar caar)
             (list 'caddr caddr)
             (list 'cons cons)
             (list 'read read)
             (list 'append append)
             (list 'pair? pair?)
             (list 'integer? integer?)
             (list 'number? number?)
             (list 'symbol? symbol?)
             (list 'symbol->string symbol->string)
             (list 'number->string number->string)
             (list 'string=? string=?)
             (list 'substring substring)
             (list 'string->symbol string->symbol)
             (list 'string-length string-length)
             (list 'string-append string-append)
             (list 'set-cdr! set-cdr!)
             (list 'eq? eq?)
             (list 'equal? equal?)
             (list 'error error)
             (list 'null? null?)
             (list 'list list)
             (list '* *)
             (list '+ +)
             (list '- -)
             (list '/ /)
             (list 'not not)
             (list '= =)
             (list '< <)
             (list '> >)
             (list '>= >=)
             (list '<= <=)
             (list 'even? even?)
             (list 'random-integer random-integer)
             (list 'length length)
             (list 'list-ref list-ref)
             (list 'memq memq)
             (list 'member member)
             (list 'remainder remainder)
             (list 'sqrt sqrt)
             (list 'abs abs)
             (list 'assoc assoc)
             (list 'write write)
             (list 'display display)
             (list 'newline newline)
             (list 'exit exit)))

     (define (primitive-procedure-names)
       (map car primitive-procedures))

     (define (primitive-procedure-objects)
       (map (lambda (proc) (list 'primitive (cadr proc)))
            primitive-procedures))

     (define (apply-primitive-procedure proc args)
       (apply-in-underlying-scheme
         (primitive-implementation proc) args))

     ; Driver loop
     (define (driver-loop)
       (define input-prompt ";;; M-Eval input:")
       (define output-prompt ";;; M-Eval value:")
       (prompt-for-input input-prompt)
       (let ((input (read)))
         (let ((output (eval input the-global-environment)))
           (announce-output output-prompt)
           (user-print output)))
       (driver-loop))

     (define (prompt-for-input string)
       (newline) (newline) (display string) (newline))

     (define (announce-output string)
       (newline) (display string) (newline))

     (define (user-print object)
       (if (compound-procedure? object)
         (write (list 'compound-procedure
                      (procedure-parameters object)
                      (procedure-body object)
                      '<procedure-env>))
         (write object)))

     (define the-global-environment (setup-environment))))
