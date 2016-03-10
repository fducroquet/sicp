(define (make-rect s1 s2)
  (let ((s3 (make-segment (start-segment s1)
			  (start-segment s2)))
	(s4 (make-segment (end-segment s1)
			  (end-segment s2))))
    (if (or (not (parallel? s1 s2))
	    (not (parallel? s3 s4))
	    (not (perpendicular? s1 s3)))
      (error "The given segments must correspond to two opposite sides \
      	     of a rectangle and have the same orientation.")
      (cons s1 s2))))

(define (width-rect rect)
  (length s1))

(define (height-rect rect)
  (let ((s3 (make-segment (start-segment s1)
			  (start-segment s2))))
    (length s3)))

(define (first-point rect)
  (start-segment (car rect)))

(define (second-point rect)
  (end-segment (car rect)))

(define (third-point rect)
  (end-segment (cdr rect)))

(define (fourth-point rect)
  (start-segment (cdr rect)))
