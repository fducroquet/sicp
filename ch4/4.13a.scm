(define (unbind? exp)
  (tagged-list? exp 'make-unbound!))

(define (unbind-variable exp)
  (cadr exp))

(define (eval-unbind exp env)
  (unbind-var (unbind-variable exp) env))

(define (unbind-var var env)
  (if (not (delete-binding-from-frame var (first-frame env)))
    (unbind-var var (enclosing-environment env))))

; Returns true if the variable was found in the given frame, false otherwise.
(define (delete-binding-from-frame var frame)
  (define (delete prev-vars curr-vars prev-vals curr-vals)
    (if (null? curr-vars)
      false
      (if (eq? (car curr-vars) var)
        (begin
          (set-cdr! prev-vars (cdr curr-vars))
          (set-cdr! prev-vals (cdr curr-vals))
          true)
        (delete curr-vars (cdr curr-vars) curr-vals (cdr curr-vals)))))
  (let ((vars (frame-variables frame))
        (vals (frame-values frame)))
    (if (null? vars)
      false
      (if (eq? var (car vars))
        (begin
          (set-car! frame (cdr vars))
          (set-cdr! frame (cdr vals))
          true)
        (delete vars (cdr vars) vals (cdr vals))))))
