(define-macro (delay p) `(memo-proc (lambda () ,p)))

(define-macro (cons-stream a b)
                 `(cons ,a (delay ,b)))

(define the-empty-stream '())
(define (stream-null? stream) (null? stream))
