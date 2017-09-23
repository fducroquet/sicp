(define (smooth s)
  (scale-stream (add-streams s (stream-cdr s)) .5))

(define (make-zero-crossings input-stream smooth-func)
  (let ((smoothed (smooth-func input-stream)))
    (stream-map sign-change-detector
                (stream-cdr smoothed)
                smoothed)))

(define zero-crossings (make-zero-crossings sense-data smooth))
