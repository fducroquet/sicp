(define (allocate-register name)
  (if (assoc name register-table)
    (error "Multiply defined register: " name)
    (let ((new-reg (make-register name)))
      (set! register-table (cons (list name new-reg)
                                 register-table))
      new-reg)))

(define (lookup-register name)
  (let ((val (assoc name register-table)))
    (if val
      (cadr val)
      (allocate-register name))))
