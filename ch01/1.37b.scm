(define (cont-frac n d k)
  (define (rec count)
    (if (> count k)
      0
      (/ (n count)
         (+ (d count)
            (rec (+ count 1))))))
  (rec 1))
