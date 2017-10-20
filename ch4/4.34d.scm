(define (user-print object)
  (cond ((compound-procedure? object)
         (write (list 'compound-procedure
                      (procedure-parameters object)
                      (procedure-body object)
                      '<procedure-env>)))
        ((lazy-pair? object)
         (write (eval (list 'lazy-struct->pairs object) the-global-environment)))
        (else
          (write object))))
