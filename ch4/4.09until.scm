(define (until? exp)
  (tagged-list? exp 'until))

(define (until-predicate exp)
  (cadr exp))

(define (until-body exp)
  (cddr exp))

(define (until->while exp)
  (make-while (make-not (until-predicate exp))
              (sequence->exp (until-body exp))))
