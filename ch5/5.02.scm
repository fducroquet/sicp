(define fact-machine
  (make-machine
    '(n product counter)
    (list (list '> >) (list '* *) (list '+ +))
    '((assign product (const 1))
      (assign counter (const 1))
     test-counter
      (test (op >) (reg counter) (reg n))
      (branch (label fact-done))
      (assign product (op *) (reg product) (reg counter))
      (assign counter (op +) (reg counter) (const 1))
      (goto (label test-counter))
     fact-done)))
