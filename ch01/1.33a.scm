(define (sum-squares-primes a b)
  (filtered-accumulate prime? + 0 square a inc b))
