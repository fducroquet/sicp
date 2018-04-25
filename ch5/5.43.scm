(define (lambda-body exp)
  (scan-out-defines (cddr exp)))
