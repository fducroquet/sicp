(define sqrt-full
  (make-machine
    '(guess tmp x)
    (list (list '+ +) (list '- -) (list '* *) (list '/ /) (list '< <))
    '((assign guess (const 1.0))
    test-good-enough
      (assign tmp (op *) (reg guess) (reg guess))
      (assign tmp (op -) (reg tmp) (reg x))
      (test (op <) (const 0) (reg tmp))
      (branch (label after-abs))
      (assign tmp (op -) (reg tmp))
    after-abs
      (test (op <) (reg tmp) (const 0.001))
      (branch (label sqrt-done))
      (assign tmp (op /) (reg x) (reg guess))
      (assign guess (op +) (reg guess) (reg tmp))
      (assign guess (op /) (reg guess) (const 2))
      (goto (label test-good-enough))
    sqrt-done)))
