(define (let*? exp)
  (tagged-list? exp 'let*))

(define (let*-bindings exp) (cadr exp))
(define (let*-body exp) (cddr exp))

(define (make-let bindings body)
  (list 'let bindings body))

(define (let*->nested-lets exp)
  (define (make-nested-lets bindings body)
    (cond ((null? bindings)
           (sequence->exp body))
          (else
            (make-let (list (car bindings))
                      (make-nested-lets (cdr bindings) body)))))
  (make-nested-lets (let*-bindings exp) (let*-body exp)))
