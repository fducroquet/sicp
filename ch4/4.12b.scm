(define (traverse-env env var var-found-action . null-action)
  (define (env-loop env)
    (define (scan bindings)
      (let ((binding (assoc var bindings)))
        (if binding
          (var-found-action binding)
          (if (null? null-action)
            (env-loop (enclosing-environment env))
            ((car null-action) env)))))
    (if (eq? env the-empty-environment)
      (error "Unbound variable" var)
      (let ((frame (first-frame env)))
        (scan (frame-bindings frame)))))
  (env-loop env))

(define (set-binding-value! val)
  (lambda (binding)
    (set-cdr! binding val)))

(define (lookup-variable-value var env)
  (traverse-env env var cdr))

(define (set-variable-value! var val env)
  (traverse-env env var (set-binding-value! val)))

(define (define-variable! var val env)
  (traverse-env env var (set-binding-value! val)
                (lambda (env)
                  (add-binding-to-frame! var val (first-frame env)))))
