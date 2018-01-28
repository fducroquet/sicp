(define sqrt-simple
  (make-machine
    '(guess x)
    (list (list 'good-enough? good-enough?) (list 'improve improve))
    '((assign guess (const 1.0))
    test-good-enough
      (test (op good-enough?) (reg guess) (reg x))
      (branch (label sqrt-done))
      (assign guess (op improve) (reg guess) (reg x))
      (goto (label test-good-enough))
    sqrt-done)))
