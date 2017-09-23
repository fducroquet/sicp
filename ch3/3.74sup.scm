(define (sign-change-detector v1 v2)
  (cond ((and (< v1 0) (>= v2 0)) -1)
        ((and (>= v1 0) (< v2 0)) 1)
        (else 0)))

(define (list->stream elts)
  (fold-right (lambda (a b) (cons-stream a b)) '() elts))

(define sense-data
  (list->stream '(1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4)))
