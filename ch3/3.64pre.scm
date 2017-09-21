(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))
