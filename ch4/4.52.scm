(define (if-fail? exp) (tagged-list? exp 'if-fail))

(define (if-fail-test exp) (cadr exp))

(define (if-fail-failure exp) (caddr exp))

(define (analyze-if-fail exp)
  (let ((pproc (analyze (if-fail-test exp)))
        (aproc (analyze (if-fail-failure exp))))
    (lambda (env succeed fail)
      (pproc env
             succeed
             (lambda ()
               (aproc env succeed fail))))))
