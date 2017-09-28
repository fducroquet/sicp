(define (type exp) (car exp))

(define (application? exp) (not (get 'eval (type exp))))

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((application? exp)
         (apply (eval (operator exp) env)
                (list-of-values (operands exp) env)))
        (else
          ((get 'eval (type exp)) exp env))))

(put 'eval 'quote
     (lambda (exp env) (text-of-quotation exp)))
(put 'eval 'set! eval-assignment)
(put 'eval 'define eval-definition)
(put 'eval 'if eval-if)
(put 'eval 'lambda
     (lambda (exp env)
       (make-procedure (lambda-parameters exp)
                       (lambda-body exp)
                       env)))
(put 'eval 'begin
     (lambda (exp env)
       (eval-sequence (begin-actions exp) env)))
(put 'eval 'cond
     (lambda (exp env) (eval (cond->if exp) env)))
