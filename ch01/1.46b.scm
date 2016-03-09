(define (sqrt x)
  (define (improve guess)
    (average guess (/ x guess)))
  (define (good-enough? guess)
    (< (abs (- guess (improve guess)))
       (* 1e-10 guess)))
  (let ((guess 1.0))
    ((iterative-improve good-enough? improve) guess)))
