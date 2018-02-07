(define (operation-exp? exp)
  (tagged-list? exp 'op))

(define (operation-exp-op operation-exp)
  (cadr operation-exp))

(define (operation-exp-operands operation-exp)
  (cddr operation-exp))
