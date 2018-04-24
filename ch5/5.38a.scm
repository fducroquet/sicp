(define (spread-arguments operands)
  (if (null? operands)
    (empty-instruction-sequence)
    (if (= (length operands) 1)
      (compile (car operands) 'arg1 'next)
      (let ((first-operand-code (compile (car operands) 'arg1 'next))
            (second-operand-code (compile (cadr operands) 'arg2 'next)))
        (preserving
          '(env)
          first-operand-code
          (preserving '(arg1)
                      second-operand-code
                      (make-instruction-sequence '(arg1) '() '())))))))
