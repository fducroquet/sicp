(define (equal-point? p1 p2)
  (and (= (x-point p1) (x-point p2))
       (= (y-point p1) (y-point p2))))

; Version of print-point without newlines for printing of rectangles.
(define (print-point-i p)
  (display "(")
  (display (x-point p))
  (display ", ")
  (display (y-point p))
  (display ")"))

; Length of a segment.
(define (length s)
  (let ((p1 (start-segment s))
	(p2 (end-segment s)))
  (sqrt (+ (square (- (x-point p1) (x-point p2)))
	   (square (- (y-point p1) (y-point p2)))))))

; x-vect and y-vect return the coordinates of the vector with the same starting 
; point and ending point as the segment s.
(define (x-vect s)
  (- (x-point (end-segment s))
     (x-point (start-segment s))))

(define (y-vect s)
  (- (y-point (end-segment s))
     (y-point (start-segment s))))

; Mixed product of the vectors defined by s1 and s2.
(define (mixed-product s1 s2)
  (- (* (x-vect s1) (y-vect s2))
     (* (y-vect s1) (x-vect s2))))

; Scalar product of the vectors defined by s1 and s2.
(define (scalar-product s1 s2)
  (+ (* (x-vect s1) (x-vect s2))
     (* (y-vect s1) (y-vect s2))))

(define (parallel? s1 s2)
  (= (mixed-product s1 s2)
     0))

(define (perpendicular? s1 s2)
  (= (scalar-product s1 s2)
     0))

; Takes two segments with the same origin and returns the fourth point of the 
; parallelogram they define.
(define (find-fourth-point s1 s2)
  (make-point (+ (x-point (end-segment s1))
		 (x-vect s2))
	      (+ (y-point (end-segment s1))
		 (y-vect s2))))
