(define table (make-table (lambda (k1 k2)
                            (< (abs (- k1 k2)) 0.01))))
(define get (table 'lookup-proc))
(define put (table 'insert-proc!))
