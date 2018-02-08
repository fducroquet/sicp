(define fact-machine-rec
  (make-machine
    '(n val continue)
    (list (list '= =) (list '- -) (list '* *)
          (list 'read read) (list 'display display))
    '(start
      (perform (op initialize-stack))
      (assign n (op read))
      (assign continue (label fact-done))
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
    fact-done
      (perform (op display) (reg val))
      (perform (op print-stack-statistics))
      (goto (label start)))))
