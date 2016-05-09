(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (edge2-frame frame)
  (caddr frame))
