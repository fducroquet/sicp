(define (simple-flatten stream)
  (stream-map stream-car
              (stream-filter (lambda (stream)
                               (not (stream-null? stream)))
                             stream)))
