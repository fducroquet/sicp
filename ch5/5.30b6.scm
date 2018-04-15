(define (check-div-by-0 args)
  (if (= 0 (if (= (length args) 1)
             (car args)
             (apply * (cdr args))))
    "Division by zero."
    true))

(define (divisor-not-null args)
  (or (not (eq? 0 (cadr args)))
      "Division by zero."))
