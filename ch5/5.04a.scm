(define expt-rec
  (make-machine
    '(b n val continue)
    (list (list '= =) (list '- -) (list '* *))
    '((assign continue (label expt-done))
    expt-loop
      (test (op =) (reg n) (const 0))
      (branch (label base-case))
      (save continue)
      (assign continue (label after-expt))
      (save n)
      (assign n (op -) (reg n) (const 1))
      (goto (label expt-loop))
    after-expt
      (restore n)
      (restore continue)
      (assign val (op *) (reg b) (reg val))
      (goto (reg continue))
    base-case
      (assign val (const 1))
      (goto (reg continue))
    expt-done)))
