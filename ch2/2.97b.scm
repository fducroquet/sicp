(define (make-rat n d)
  (let ((reduced (reduce n d)))
    (cons (car reduced) (cadr reduced))))
