(define (make-rect a b c d)
  (let ((s1 (make-segment a b))
	(s2 (make-segment b c))
	(s3 (make-segment c d))
	(s4 (make-segment d a)))
  (if (or (not (perpendicular? s1 s2))
	  (not (parallel? s1 s3))
	  (not (parallel? s2 s4)))
    (error "The given points don’t correspond to the vertices of a rectangle.")
    (cons (cons a b) (cons c d)))))

(define (width-rect rect)
  (length (make-segment (car (car rect))
			(cdr (car rect)))))

(define (height-rect rect)
  (length (make-segment (cdr (car rect))
			(car (cdr rect)))))

(define (first-point rect)
  (car (car rect)))

(define (second-point rect)
  (cdr (car rect)))

(define (third-point rect)
  (car (cdr rect)))

(define (fourth-point rect)
  (cdr (cdr rect)))
