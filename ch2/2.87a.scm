(define (=zero-terms? L)
  (if (empty-termlist? L)
    true
    (and (=zero? (coeff (first-term L)))
         (=zero-terms? (rest-terms L)))))
