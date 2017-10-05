(define (for? exp)
  (tagged-list? exp 'for))

(define (for-body exp)
  (cddr exp))

(define (for-range-def exp)
  (cadr exp))

(define (for-variable exp)
  (car (for-range-def exp)))

(define (for-in-type? exp)
  (eq? (cadr (for-range-def exp)) 'in))

(define (for-start exp)
  (cadr (for-range-def exp)))

(define (make-set! name value)
  (list 'set! name value))

; Returns true if var appears as a free variable in the given expression.
(define (has-free-var? exp var)
  (cond ((variable? exp)
         (eq? exp var))
        ((lambda? exp)
         (and (not (memq var (lambda-parameters exp)))
              (has-free-var? (lambda-body exp) var)))
        ((definition? exp)
         (let ((def-var (definition-variable exp)))
           (and (not (if (variable? def-var)
                       (eq? var def-var)
                       (memq var def-var)))
                (has-free-var? (definition-value exp) var))))
        ((pair? exp)
         (or (has-free-var? (car exp) var)
             (has-free-var? (cdr exp) var)))
        (else false)))

; Returns a procedure taking as a parameter the variable of the for loop.
; The for loop is executed as long as this procedure returns true.
(define (for-end-test exp)
  (let ((var (for-variable exp))
        (end-exp (caddr (for-range-def exp))))
    (make-lambda
      (list var)
      (if (has-free-var? end-exp var)
        (list end-exp)
        (list
          (list (make-if (list '<= (for-start exp) end-exp) '<= '>=)
                var
                end-exp))))))

; Returns a procedure computing the new value of the variable from its current 
; value.
(define (for-inc exp)
  (let* ((var (for-variable exp))
         (range-def (for-range-def exp))
         (inc (if (null? (cdddr range-def)) 1 (cadddr range-def))))
    (make-lambda (list var)
                 (if (has-free-var? inc var)
                   (list inc)
                   (list (list '+ var inc))))))

; Transforms a for expression into a let expression containing a while loop.
(define (for->let exp)
  (let ((var (for-variable exp)))
    (make-let (list (list var (for-start exp)))
              (make-while
                (list (for-end-test exp) var)
                (sequence->exp
                  (append
                    (for-body exp)
                    (list
                      (make-set! var
                                 (list (for-inc exp) var)))))))))
