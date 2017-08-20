(define (gcd-terms a b)
  (if (empty-termlist? b)
    (let* ((coeffs-gcd (gcd-terms-coeffs a)))
      (divide-terms-by-int a coeffs-gcd))
    (gcd-terms b (pseudoremainder-terms a b))))

(define (divide-terms-by-int term-list n)
  (mul-term-by-all-terms (make-term 0 (make-rational 1 n)) term-list))

(define (gcd-terms-coeffs term-list)
  (cond ((empty-termlist? term-list)
         0)
        ((not (eq? (type-tag (coeff (first-term term-list)))
                   'integer))
         (error "Trying to compute GCD of a non-integer."
                term-list))
        (else
          (gcd (coeff (first-term term-list))
               (gcd-terms-coeffs (rest-terms term-list))))))
