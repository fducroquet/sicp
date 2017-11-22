(define (require-fail? exp) (tagged-list? exp 'require-fail))

(define (require-fail-test exp) (cadr exp))

(define (analyze-require-fail exp)
  (let ((pproc (analyze (require-fail-test exp))))
    (lambda (env succeed fail)
      (pproc env
             (lambda (val fail2)
               (fail))
             (lambda ()
               (succeed #t fail))))))
