(define (product-n-primes n)
  (define (n-prime? i)
    (= (gcd i n) 1))
  (filtered-accumulate n-prime? * 1 identity 1 inc n))
