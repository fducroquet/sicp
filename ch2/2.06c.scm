(define (+ n m)
  (lambda (f)
    (lambda (x)
      ((n f) ((m f) x)))))
