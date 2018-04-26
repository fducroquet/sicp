(define (compile-and-assemble exp)
  (assemble (statements (compile exp 'val 'return)) eceval))
