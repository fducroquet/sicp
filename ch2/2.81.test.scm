(load "2.78.test.scm")
(load "2.79a.scm")
(define (numer x)
  (apply-generic 'numer x))
(define (denom x)
  (apply-generic 'denom x))
(put 'numer '(rational) car)
(put 'denom '(rational) cdr)
(load "2.79b.scm")
(load "2.80.scm")

(define coercion-table (make-table))
(define get-coercion (operation-table 'lookup-proc))
(define put-coercion (operation-table 'insert-proc!))
(load "2.81pre.scm")

(define (exp z n)
  (apply-generic 'exp z n))
(put 'exp '(complex scheme-number)
     (lambda (z n)
       (make-complex-from-mag-ang (expt (magnitude z) n)
                                  (* n (angle z)))))

(load "2.81.scm")
