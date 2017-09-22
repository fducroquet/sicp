(define (all-pairs s t)
  (cons-stream
    (list (stream-car s) (stream-car t))
    (interleave
      (interleave
        (stream-map (lambda (x) (list (stream-car s) x))
                    (stream-cdr t))
        (stream-map (lambda (x) (list x (stream-car s)))
                    (stream-cdr t)))
      (all-pairs (stream-cdr s) (stream-cdr t)))))

(define all-int-pairs (all-pairs integers integers))
