(define (require? exp) (tagged-list? exp 'require))

(define (require-predicate exp) (cadr exp))
