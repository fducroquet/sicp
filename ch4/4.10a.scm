(define (and? exp)
  (tagged-list? exp '&&))

(define (or? exp)
  (tagged-list? exp '||))

(define (cond? exp)
  (tagged-list? exp 'case))
