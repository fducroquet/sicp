(define int-pairs (pairs integers integers))

(define prime-sum-stream
  (stream-filter (lambda (pair)
                   (prime? (+ (car pair) (cadr pair))))
                 int-pairs))
