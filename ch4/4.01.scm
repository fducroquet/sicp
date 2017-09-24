(define (list-of-values-ltr exps env)
  (if (no-operands? exps)
    '()
    (let ((first-value (eval (first-operand exps) env)))
      (cons first-value
            (list-of-values-ltr (rest-operands exps) env)))))

(define (list-of-values-rtl exps env)
  (if (no-operands? exps)
    '()
    (let ((rest-values (list-of-values-rtl (rest-operands exps) env)))
      (cons first-value rest-values))))
