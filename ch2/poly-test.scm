(load "2.86.test.scm")
(load "polynomial-package-dense-sparse.scm")
(define tower '(integer rational real complex polynomial))
(install-polynomial-package)
(load "2.88a.scm")
(install-dense-termlist-package)
(install-sparse-termlist-package)

(put 'no-drop? 'div true)

(define a (make-polynomial 'x '(dense 1 2 0 3 -2 -5)))
(define b (make-polynomial 'x '(sparse (100 1) (2 2) (0 1))))

(define p1 (make-polynomial 'x '(sparse (2 1) (1 2) (0 1))))
(define p2 (make-polynomial 'x `(dense 1 0 ,(make-rational 1 2) ,(make-rational 5 8))))

(define p3 (make-polynomial 'x '(dense 1 2 0 3 -2 -5)))
(define p4 (make-polynomial 'x '(dense 1 0 0 0 0 0 0 0 0 2 1)))

(define p6 (make-polynomial 'x '(dense 1 0 0 0 0 -1)))
(define p7 (make-polynomial 'x '(dense 1 0 -1)))
(define p8 (make-polynomial 'x '(sparse (5 1) (0 -1))))
(define p9 (make-polynomial 'x '(sparse (2 1) (0 -1))))
