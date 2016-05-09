(define (split op-glob op-smaller)
  (define (rec painter n)
    (if (= n 0)
      painter
      (let ((smaller (rec painter (- n 1))))
        (op-glob painter (op-smaller smaller smaller)))))
  rec)
