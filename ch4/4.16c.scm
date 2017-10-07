(define (make-procedure parameters body env)
  (list 'procedure parameters (scan-out-defines body) env))
