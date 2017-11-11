(define (uniquely-asserted query frame-stream)
  (simple-stream-flatmap
    (lambda (frame)
      (let ((result-stream (qeval (unique-query query)
                                  (singleton-stream frame))))
        (if (singleton-stream? result-stream)
          result-stream
          the-empty-stream)))
    frame-stream))

(put 'unique 'qeval uniquely-asserted)

(define (singleton-stream? stream)
  (and (not (stream-null? stream))
       (stream-null? (stream-cdr stream))))

(define (unique-query exps) (car exps))
