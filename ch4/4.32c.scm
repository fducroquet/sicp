(define (length l)
  (if (null? l)
    0
    (+ 1 (length (cdr l)))))
