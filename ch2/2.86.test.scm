(load "2.85.test.scm")
(load "2.86.scm")

(install-rectangular-package)
(install-polar-package)
(install-complex-package)
(install-number-package-ext 'integer)
(install-number-package-ext 'real)

(define z5 (make-complex-from-real-imag r1 r2))
(define z6 (make-complex-from-mag-ang r1 r2))
