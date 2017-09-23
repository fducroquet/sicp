(define (make-zero-crossings input-stream last-value)
  (if (stream-null? input-stream)
    the-empty-stream
    (cons-stream
      (sign-change-detector (stream-car input-stream) last-value)
      (make-zero-crossings (stream-cdr input-stream)
                           (stream-car input-stream)))))

(define zero-crossings (make-zero-crossings sense-data 0))
