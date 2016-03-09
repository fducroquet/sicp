(define (iterative-improve good-enough? improve)
  (define (result guess)
    (if (good-enough? guess)
      guess
      (result (improve guess))))
  result)
