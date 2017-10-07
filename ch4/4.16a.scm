(define (lookup-variable-value var env)
  (traverse-env env
                var
                (lambda (binding)
                  (let ((value (cdr binding)))
                    (if (eq? value '*unassigned*)
                      (error "Unassigned variable" var)
                      value))))) 
