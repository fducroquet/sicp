(define fib-machine2
  (make-machine
    '(n val continue)
    (list (list '< <) (list '- -) (list '+ +))
    '((assign continue (label fib-done))
    fib-loop
      (test (op <) (reg n) (const 2))
      (branch (label immediate-answer))
      (save continue)
      (assign continue (label after-fib-n-1))
      (save n)
      (assign n (op -) (reg n) (const 1))
      (goto (label fib-loop))
    after-fib-n-1
      (restore n)
      (restore continue)
      (assign n (op -) (reg n) (const 2))
      (save continue)
      (assign continue (label after-fib-n-2))
      (save val)
      (goto (label fib-loop))
    after-fib-n-2
      (restore n)
      (restore continue)
      (assign val (op +) (reg n) (reg val))
      (goto (reg continue))
    immediate-answer
      (assign val (reg n))
      (goto (reg continue))
    fib-done)))
