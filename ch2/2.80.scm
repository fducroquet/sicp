(define (=zero? x) (apply-generic '=zero? x))

(put '=zero? '(scheme-number)
     (lambda (x) (= x 0)))

(put '=zero? '(rational)
     (lambda (r) (= (numer r) 0)))

(put '=zero? '(complex)
     (lambda (z) (= (magnitude z) 0)))
