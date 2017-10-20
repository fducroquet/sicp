(define underlying-cons cons)
(define underlying-car car)
(define underlying-cdr cdr)

(define (cons x y)
  (underlying-cons 'lazy-pair (lambda (m) (m x y))))

(define (lazy-pair? x)
  (and (pair? x)
       (eq? (underlying-car x) 'lazy-pair)))

(define (car z)
  (if (lazy-pair? z)
    ((underlying-cdr z) (lambda (p q) p))
    (error "Not a pair -- CAR" z)))

(define (cdr z)
  (if (lazy-pair? z)
    ((underlying-cdr z) (lambda (p q) q))
    (error "Not a pair -- CDR" z)))
