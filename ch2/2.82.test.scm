(load "2.81.test.scm")
(load "2.82.scm")

(define (add x y z)
  (apply-generic 'add x y z))

(put 'add '(complex complex complex)
     (lambda (x y z)
       (make-complex-from-real-imag (+ (real-part x)
                                       (real-part y)
                                       (real-part z))
                                    (+ (imag-part x)
                                       (imag-part y)
                                       (imag-part z)))))

(put-coercion 'rational 'complex
               (lambda (r)
                 (make-complex-from-real-imag (exact->inexact (/ (numer r)
                                                                (denom r)))
                                              0)))
