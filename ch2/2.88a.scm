(define (neg x)
  (apply-generic 'neg x))

(put 'neg '(integer)
     (lambda (x) (make-integer (- x))))
(put 'neg '(rational)
     (lambda (r)
       (make-rational (- (numer r))
                      (denom r))))
(put 'neg '(real)
     (lambda (x) (make-real (- x))))
(put 'neg '(complex)
     (lambda (z)
       (make-complex-from-real-imag (neg (real-part z))
                                    (neg (imag-part z)))))
