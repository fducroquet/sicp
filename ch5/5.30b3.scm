(define (pair-cdr-arg args)
  (or (pair? (cdr (car args)))
      "The argument’s cdr must be a pair."))

(define (pair-car-arg args)
  (or (pair? (car (car args)))
      "The argument’s car must be a pair."))

(define (pair-cddr-arg args)
  (or (pair? (cdr (cdr (car args))))
      "The argument’s cddr must be a pair."))
