(define a (make-connector))
(define b (make-connector))
(define c (make-connector))

(probe 'a a)
(probe 'b b)
(probe 'c c)

(averager a b c)
