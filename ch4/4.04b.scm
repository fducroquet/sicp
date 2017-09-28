; And
(define (and? exp)
  (tagged-list? exp 'and))

(define (and-tests exp)
  (cdr exp))

(define (eval-and exp env)
  (define (eval-exps exps)
    (let ((first (eval (car exps) env)))
      (if (true? first)
        (if (last-exp? exps)
          first
          (eval-exps (cdr exps)))
        false)))
  (let ((exps (and-tests exp)))
    (if (null? exps)
      true
      (eval-exps exps))))

; Or
(define (or? exp)
  (tagged-list? exp 'or))

(define (or-tests exp)
  (cdr exp))

(define (eval-or exp env)
  (define (eval-exps exps)
    (if (null? exps)
      false
      (let ((first (eval (car exps) env)))
        (if (true? first)
          first
          (eval-exps (cdr exps))))))
  (let ((exps (or-tests exp)))
    (eval-exps exps)))
