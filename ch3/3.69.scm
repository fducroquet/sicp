(define (triples s t u)
  (cons-stream
    (list (stream-car s) (stream-car t) (stream-car u))
    (interleave (stream-map (lambda (pair) (cons (stream-car s) pair))
                            (stream-cdr (pairs t u)))
                (triples (stream-cdr s) (stream-cdr t) (stream-cdr u)))))

(define triples-stream (triples integers integers integers))

(define pythagoreans-stream
  (stream-filter (lambda (triple)
                   (= (+ (square (car triple)) (square (cadr triple)))
                      (square (caddr triple))))
                 triples-stream))
