(define (named-let? exp) (variable? (cadr exp)))

(define (let-name exp) (cadr exp))

(define (let-bindings exp)
  (if (named-let? exp)
    (caddr exp)
    (cadr exp)))

(define (let-body exp)
  (if (named-let? exp)
    (cdddr exp)
    (cddr exp)))

(define (make-define name value)
  (list 'define name value))

(define (let->combination exp)
  (let ((bindings (let-bindings exp)))
    (if (named-let? exp)
      (make-begin
        (list (make-define (cons (let-name exp) (let-vars exp))
                           (sequence->exp (let-body exp)))
              (cons (let-name exp) (let-args exp))))
      (cons (make-lambda (let-vars exp)
                         (let-body exp))
            (let-args exp)))))
