(put 'equ? '(scheme-number scheme-number) =)

(put 'equ? '(rational rational)
     (lambda (x y) (= (* (numer x) (denom y))
                      (* (numer y) (denom x)))))

(put 'equ? '(complex complex)
     (lambda (z1 z2)
       (and (equ? (real-part z1) (real-part z2))
            (equ? (imag-part z1) (imag-part z2)))))
