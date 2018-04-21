(define false #f)
(define true #t)

(define apply-in-underlying-scheme apply)

;; Syntax procedures from section 4.1.2
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

;; Added for exercise 5.23.
; Cond
(define (cond? exp) (tagged-list? exp 'cond))

(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))

(define (cond-predicate clause) (car clause))

(define (cond-actions clause) (cdr clause))

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

;; Added in section 5.4
(define (empty-arglist) '())

(define (adjoin-arg arg arglist)
  (append arglist (list arg)))

(define (last-operand? ops) (null? (cdr ops)))

(define (no-more-exps? seq) (null? seq))

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

(define (primitive-checks proc) (caddr proc))

(define primitive-procedures
  (list (list 'car car (arity 1) (arg-type 0 pair?))
        (list 'cdr cdr (arity 1) (arg-type 0 pair?))
        (list 'cadr cadr (arity 1) (arg-type 0 pair?) pair-cdr-arg)
        (list 'cdar cdar (arity 1) (arg-type 0 pair?) pair-car-arg)
        (list 'cddr cddr (arity 1) (arg-type 0 pair?) pair-cdr-arg)
        (list 'caar caar (arity 1) (arg-type 0 pair?) pair-car-arg)
        (list 'caddr caddr (arity 1) (arg-type 0 pair?) pair-cdr-arg pair-cddr-arg)
        (list 'cons cons (arity 2))
        (list 'read read (arity 0))
        (list 'append append (args-type list?))
        (list 'pair? pair? (arity 1))
        (list 'integer? integer? (arity 1))
        (list 'number? number? (arity 1))
        (list 'symbol? symbol? (arity 1))
        (list 'symbol->string symbol->string (arity 1) (args-type symbol?))
        (list 'number->string number->string (arity 1) (args-type number?))
        (list 'string=? string=? (args-type string?))
        (list 'substring substring (arity 3) (arg-type 0 string?) (arg-type 1 integer?)
              (arg-type 2 integer?) substring-range-check)
        (list 'string->symbol string->symbol (arity 1) (arg-type 0 string?))
        (list 'string-length string-length (arity 1) (arg-type 0 string?))
        (list 'string-append string-append (args-type string?))
        (list 'set-cdr! set-cdr! (arity 2) (arg-type 0 pair?))
        (list 'eq? eq? (arity 2))
        (list 'equal? equal? (arity 2))
        (list 'error error pos-arity)
        (list 'apply apply-in-underlying-scheme (arity 2) (arg-type 0 procedure?)
              (arg-type 1 list))
        (list 'null? null? (arity 1))
        (list 'list list)
        (list '* * (args-type number?))
        (list '+ + (args-type number?))
        (list '- - pos-arity (args-type number?))
        (list '/ / pos-arity (args-type number?) check-div-by-0)
        (list 'not not (arity 1))
        (list '= = (args-type number?))
        (list '< < (args-type real?))
        (list '> > (args-type real?))
        (list '>= >= (args-type real?))
        (list '<= <= (args-type real?))
        (list 'even? even? (arity 1) (arg-type 0 integer?))
        (list 'random-integer random-integer (arity 1) (arg-type 0 integer?))
        (list 'length length (arity 1) (args-type list?))
        (list 'list-ref list-ref (arity 2) (arg-type 0 list?) (arg-type 1 integer?)
              list-ref-range-check)
        (list 'memq memq (arity 2) (arg-type 1 list?))
        (list 'member member (arity 2) (arg-type 1 list?))
        (list 'remainder remainder (arity 2) (args-type integer?) divisor-not-null)
        (list 'sqrt sqrt (arity 1) (arg-type 0 number?))
        (list 'abs abs (arity 1) (arg-type 0 real?))
        (list 'assoc assoc (arity 2) (arg-type 1 association-list?))
        (list 'write write (arity 1))
        (list 'display display (arity 1))
        (list 'newline newline (arity 0))
        (list 'exit exit (arity 0))))

(define (primitive-procedure-names)
  (map car primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc) (cddr proc)))
       primitive-procedures))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
    (primitive-implementation proc) args))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (cond ((compound-procedure? object)
         (write (list 'compound-procedure
                      (procedure-parameters object)
                      (procedure-body object)
                      '<procedure-env>)))
        ((compiled-procedure? object)
         (display '<compiled-procedure>))
        (else (display object))))

(define (get-global-environment)
  the-global-environment)
