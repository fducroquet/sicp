(define (make-rect s1 s2)
  (if (not (equal-point? (start-segment s1) (start-segment s2)))
    (error "The two segments must have the same origin.")
    (if (not (perpendicular? s1 s2))
      (error "The two segments must be perpendicular.")
      (cons s1 s2))))

(define (width-rect rect)
  (length (car rect)))

(define (height-rect rect)
  (length (cdr rect)))

(define (first-point rect)
  (start-segment (car rect)))

(define (second-point rect)
  (end-segment (car rect)))

(define (third-point rect)
  (find-fourth-point (car rect) (cdr rect)))

(define (fourth-point rect)
  (end-segment (cdr rect)))
