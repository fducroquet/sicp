(define (let? exp)
  (tagged-list? exp 'let))

(define (let-bindings exp) (cadr exp))
(define (let-vars exp) (map car (let-bindings exp)))
(define (let-args exp) (map cadr (let-bindings exp)))
(define (let-body exp) (cddr exp))

(define (let->combination exp)
  (let ((bindings (let-bindings exp)))
    (cons (make-lambda (let-vars exp)
                       (let-body exp))
          (let-args exp))))
