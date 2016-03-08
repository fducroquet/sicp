(define (approx-e k)
  (+ 2
     (cont-frac (lambda (i) 1.0)
                (lambda (i)
                  (if (= (remainder i 3) 2)
                    (* 2 (+ 1 (quotient i 3)))
                    1))
                k)))
