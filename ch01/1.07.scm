(define (sqrt-iter guess x)
  (define new-guess (improve guess x))
  ; let would be better than define here, but it has not been introduced in 
  ; the book yet.
  (if (good-enough? guess new-guess)
      guess
      (sqrt-iter new-guess
                 x)))

(define (good-enough? guess new-guess)
  (<= (abs (- guess new-guess))
      (* 1e-5 guess)))
