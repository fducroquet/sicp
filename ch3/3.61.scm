(define (invert-unit-series s)
  (define inverse (cons-stream 1
                               (stream-map - (mul-series inverse
                                                         (stream-cdr s)))))
  inverse)
