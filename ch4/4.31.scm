(define (delay-it-no-memo exp env)
  (list 'thunk-no-memo exp env))

(define (thunk-no-memo? exp)
  (tagged-list? exp 'thunk-no-memo))

(define (ext-force-it obj)
  (cond ((thunk? obj)
         (let ((result (actual-value
                         (thunk-exp obj)
                         (thunk-env obj))))
           (set-car! obj 'evaluated-thunk)
           (set-car! (cdr obj) result)
           (set-cdr! (cdr obj) '())
           result))
        ((thunk-no-memo? obj)
         (actual-value (thunk-exp obj) (thunk-env obj)))
        ((evaluated-thunk? obj)
         (thunk-value obj))
        (else obj)))

(define (ext-apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
           procedure
           (list-of-arg-values arguments env)))
        ((compound-procedure? procedure)
         (let* ((params (procedure-parameters procedure))
                (param-names (map (lambda (x) (if (list? x) (car x) x))
                                  params))
                (param-types (map (lambda (x) (if (list? x) (cadr x) 'default))
                                  params)))
           (eval-sequence
             (procedure-body procedure)
             (extend-environment
               param-names
               (ext-list-of-delayed-args arguments param-types env)
               (procedure-environment procedure)))))
        (else
          (error
            "Unknown procedure type -- APPLY" procedure))))

(define (ext-list-of-delayed-args exps types env)
  (define (value exp type)
    (cond ((eq? 'default type)
           (actual-value exp env))
          ((eq? 'lazy type)
           (delay-it-no-memo exp env))
          ((eq? 'lazy-memo type)
           (delay-it exp env))
          (else
            (error "Unknown argument type -- LIST-OF-ARGUMENTS" type))))
  (if (no-operands? exps)
    '()
    (cons (value (first-operand exps) (car types))
          (ext-list-of-delayed-args (rest-operands exps)
                                (cdr types)
                                env))))
