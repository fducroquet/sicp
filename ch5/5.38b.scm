(define (native-op? exp)
  (and (application? exp)
       (memq (operator exp) '(= + - * /))))

(define (compile-native-op exp target linkage)
  (let ((op (operator exp))
        (operands (operands exp)))
    (if (and (null? operands)
             (memq op '(- /)))
      (error "Operation takes at least one argument -- COMPILE" op)
      (let ((arg-regs
              (cond ((null? operands) '())
                    ((= (length operands) 1) '((reg arg1)))
                    (else '((reg arg1) (reg arg2)))))
            (operands-code (spread-arguments operands)))
        (end-with-linkage
          linkage
          (append-instruction-sequences
            operands-code
            (make-instruction-sequence
              '(arg1 arg2)
              (list target)
              (list (append `(assign ,target (op ,op))
                            arg-regs)))))))))
