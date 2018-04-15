(define (check-primitive-arguments proc args)
  (define (test checks)
    (if (null? checks)
      true
      (let ((result ((car checks) args)))
        (if (eq? result true)
          (test (cdr checks))
          result))))
  (test (primitive-checks proc)))
