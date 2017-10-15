(define l1 (cons 1 (cons 2 (cons 3 '()))))

(define l2 (map (lambda (x) (/ x 0)) l1))
