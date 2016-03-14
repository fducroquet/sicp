(define (fixed-point f first-guess)
  (define tolerance 0.00001)
  (define (close-enough? guess)
    (< (abs (- guess (f guess))) tolerance))
  ((iterative-improve close-enough? f) first-guess))