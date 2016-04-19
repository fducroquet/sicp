(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms)
                (+ (* x higher-terms)
                   this-coeff))
              0
              coefficient-sequence))
