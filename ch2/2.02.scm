(define (make-segment p1 p2)
  (cons p1 p2))

(define (start-segment s)
  (car s))

(define (end-segment s)
  (cdr s))

(define (make-point x y)
  (cons x y))

(define (x-point p)
  (car p))

(define (y-point p)
  (cdr p))

(define (midpoint-segment s)
  (make-point (average (x-point (start-segment s))
		       (x-point (end-segment s)))
	      (average (y-point (start-segment s))
		       (y-point (end-segment s)))))
