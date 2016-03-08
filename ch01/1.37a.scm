(define (cont-frac n d k)
  (define (iter res k)
    (if (= k 0)
      res
      (iter (/ (n k)
               (+ (d k) res))
            (- k 1))))
  (iter 0 k))
