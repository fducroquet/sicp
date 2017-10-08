(define (letrec? exp)
  (tagged-list? exp 'letrec))

(define (letrec-bindings exp)
  (cadr exp))

(define (letrec-body exp)
  (cddr exp))

(define (letrec->let exp)
  (let* ((bindings (letrec-bindings exp))
         (vars (map car bindings))
         (vals (map cadr bindings)))
    (if (null? vars)
      (letrec-body exp)
      (make-let (map (lambda (var)
                       (list var ''*unassigned*))
                     vars)
                (sequence->exp
                  (append
                    (map (lambda (var val)
                           (make-set! var val))
                         vars
                         vals)
                    (letrec-body exp)))))))
