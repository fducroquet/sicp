(load "2.86.test.scm")
(load "polynomial-package.scm")
(define tower '(integer rational real complex polynomial))
(install-polynomial-package)
(load "2.88a.scm")

(define a (make-polynomial 'x '((5 1) (4 2) (2 3) (1 -2) (0 -5))))
(define b (make-polynomial 'x '((100 1) (2 2) (0 1))))

(define p1 (make-polynomial 'x '((2 1) (1 2) (0 1))))
(define p2 (make-polynomial 'x (list '(3 1) (list 1 (make-rational 1 2)) (list 0 (make-rational 5 8)))))
