(define (construct-arglist operand-codes)
  (if (null? operand-codes)
    (make-instruction-sequence '()
                               '(argl)
                               '((assign argl (const ()))))
    (let ((code-to-get-first-arg
            (append-instruction-sequences
              (car operand-codes)
              (make-instruction-sequence '(val)
                                         '(argl)
                                         '((assign argl (op list) (reg val)))))))
      (if (null? (cdr operand-codes))
        code-to-get-first-arg
        (append-instruction-sequences
          (preserving '(env)
                      code-to-get-first-arg
                      (code-to-get-rest-args (cdr operand-codes)))
          (make-instruction-sequence '(argl)
                                     '(argl)
                                     '((assign argl (op reverse) (reg argl)))))))))
