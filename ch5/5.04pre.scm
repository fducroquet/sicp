(define fact-machine-rec
  (make-machine
    '(n val continue)
    (list (list '= =) (list '- -) (list '* *))
    '((assign continue (label fact-done))
    fact-loop
      (test (op =) (reg n) (const 1))
      (branch (label base-case))
      (save continue)
      (save n)
      (assign n (op -) (reg n) (const 1))
      (assign continue (label after-fact))
      (goto (label fact-loop))
    after-fact
      (restore n)
      (restore continue)
      (assign val (op *) (reg val) (reg n))
      (goto (reg continue))
    base-case
      (assign val (const 1))
      (goto (reg continue))
    fact-done)))

(define fib-machine
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
      (assign continue (label after-fact-n-2))
      (save val)
      (goto (label fib-loop))
    after-fact-n-2
      (assign n (reg val))
      (restore val)
      (restore continue)
      (assign val (op +) (reg n) (reg val))
      (goto (reg continue))
    immediate-answer
      (assign val (reg n))
      (goto (reg continue))
    fib-done)))
