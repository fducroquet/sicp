(define x (list 'a 'b 'c))

(define b-nil (cons 'b '()))
(define y (cons b-nil (cons 'a b-nil)))

(define a-nil (cons 'a '()))
(define z1 (cons a-nil a-nil))
(define z (cons z1 z1))

(define t (make-cycle (list 'a 'b 'c)))
