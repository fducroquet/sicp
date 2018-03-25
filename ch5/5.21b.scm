(define count-leaves-counter
  (make-machine
    ; Result in counter register at the end of the computation.
    '(tree counter continue)
    (list (list '+ +) (list 'car car) (list 'cdr cdr)
          (list 'null? null?) (list 'pair? pair?))
    '((assign continue (label count-done))
      (assign counter (const 0))
    count-iter
      (test (op null?) (reg tree))
      (branch (label null-tree))
      (test (op pair?) (reg tree))
      (branch (label pair-tree))
      (assign counter (op +) (reg counter) (const 1))
      (goto (reg continue))
    pair-tree
      (save tree)
      (assign tree (op car) (reg tree))
      (save continue)
      (assign continue (label after-car-tree))
      (goto (label count-iter))
    after-car-tree
      (restore continue)
      (restore tree)
      (assign tree (op cdr) (reg tree))
      (goto (label count-iter))
     null-tree
      (goto (reg continue))
    count-done)))
