(define lowest-level
  (car tower))

(define (drop x)
  (if (eq? (type-tag x) lowest-level)
    x
    (let ((proj (project x)))
      (if (equ? (raise proj) x)
        (drop proj)
        x))))

(define (project x)
  (apply-generic 'project x))

(put 'project '(rational)
     (lambda (r)
       (make-integer (quotient (numer r)
                               (denom r)))))
(put 'project '(real)
     (lambda (x)
       (make-integer (inexact->exact (round x)))))
(put 'project '(complex)
     (lambda (x)
       (make-real (real-part x))))
