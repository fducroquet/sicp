(define int-stream (stream-filter
                     (lambda (x)
                       (not (or (divides? 2 x)
                                (divides? 3 x)
                                (divides? 5 x))))
                     integers))

(define stream-235
  (weighted-pairs int-stream
                  int-stream
                  (lambda (pair)
                    (+ (* 2 (car pair))
                       (* 3 (cadr pair))
                       (* 5 (car pair) (cadr pair))))))
