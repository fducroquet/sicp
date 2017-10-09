(define (try a b)
  (if (= a 0) 1 b))

(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))
