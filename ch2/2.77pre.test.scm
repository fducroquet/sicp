(load "../ch1/utils.scm")
(load "associative-table.scm")

(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
    (car datum)
    (error "Bad tagged datum -- TYPE_TAG" datum)))

(define (contents datum)
  (if (pair? datum)
    (cdr datum)
    (error "Bad tagged datum -- CONTENTS" datum)))

(load "2.73pre.scm")
(install-rectangular-package)
(install-polar-package)

(load "2.77pre.scm")
(install-scheme-number-package)
(install-rational-package)
(install-complex-package)

(define n1 (make-scheme-number 3))
(define n2 (make-scheme-number 5))
(define r1 (make-rational 3 5))
(define r2 (make-rational 8 3 ))
(define z1 (make-complex-from-real-imag 3 4))
(define z2 (make-complex-from-real-imag 5 -2))
(define z3 (make-complex-from-mag-ang 2 0))
(define z4 (make-complex-from-mag-ang 1.42 .785))
