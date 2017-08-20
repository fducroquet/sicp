(load "2.86.test.scm")
(load "polynomial-package-dense-sparse.scm")
(define tower '(integer rational real complex polynomial))
(install-polynomial-package)
(load "2.88a.scm")
(install-dense-termlist-package)
(install-sparse-termlist-package)

(load "2.97rat.scm")
(load "2.93sup.scm")
(install-rational-package)

(define p1 (make-polynomial 'x '(sparse (1 1) (0 1))))
(define p2 (make-polynomial 'x '(sparse (3 1) (0 -1))))
(define p3 (make-polynomial 'x '(sparse (1 1))))
(define p4 (make-polynomial 'x '(sparse (2 1) (0 -1))))

(define rf1 (make-rational p1 p2))
(define rf2 (make-rational p3 p4))
