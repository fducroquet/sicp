(define (remainder-terms a b)
  (cadr (div-terms a b)))

(define (gcd-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
    (make-poly (variable p1)
               (gcd-terms (term-list p1) (term-list p2)))
    (error "Polys not in same var -- GCD-POLY"
           (list p1 p2))))
