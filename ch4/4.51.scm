(define (permanent-assignment? exp)
  (tagged-list? exp 'permanent-set!))

(define (permanent-assignment-variable exp) (cadr exp))

(define (permanent-assignment-value exp) (caddr exp))

(define (analyze-permanent-assignment exp)
  (let ((var (permanent-assignment-variable exp))
        (vproc (analyze (permanent-assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
             (lambda (val fail2)
               (set-variable-value! var val env)
               (succeed 'ok fail2))
             fail))))
