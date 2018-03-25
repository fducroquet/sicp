(define count-leaves-rec
  (make-machine
    ; Result in val register at the end of the computation.
    '(tree val tmp continue)
    (list (list '+ +) (list 'car car) (list 'cdr cdr)
          (list 'null? null?) (list 'pair? pair?))
    '((assign continue (label count-done))
    count-start
      (test (op null?) (reg tree))
      (branch (label null-tree))
      (test (op pair?) (reg tree))
      (branch (label pair-tree))
      (assign val (const 1))
      (goto (reg continue))
    pair-tree
      (save continue)
      (assign continue (label after-count-car))
      (save tree)
      (assign tree (op car) (reg tree))
      (goto (label count-start))
    after-count-car
      (restore tree)
      (assign tree (op cdr) (reg tree))
      (assign continue (label after-count-cdr))
      (save val)
      (goto (label count-start))
    after-count-cdr
      (assign tmp (reg val))
      (restore val)
      (assign val (op +) (reg val) (reg tmp))
      (restore continue)
      (goto (reg continue))
    null-tree
      (assign val (const 0))
      (goto (reg continue))
    count-done)))
