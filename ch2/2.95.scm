(load "poly-test.scm")

(define p1 (make-polynomial 'x '(dense 1 -2 1)))
(define p2 (make-polynomial 'x '(dense 11 0 7)))
(define p3 (make-polynomial 'x '(dense 13 5)))
(define q1 (mul p1 p2))
(define q2 (mul p1 p3))
; (define g (greatest-common-divisor q1 q2))
