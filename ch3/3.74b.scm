(define zero-crossings
  (stream-map sign-change-detector
              (stream-cdr sense-data)
              sense-data))
