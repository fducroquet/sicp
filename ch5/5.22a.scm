(define append-machine
  (make-machine
    ; Arguments in x and y, result in result.
    '(x y result continue tmp)
    (list (list 'car car) (list 'cdr cdr)
          (list 'cons cons) (list 'null? null?))
    '((assign continue (label append-done))
    append-start
      (test (op null?) (reg x))
      (branch (label null-x))
      (save continue)
      (assign continue (label after-append-cdr))
      (save x)
      (assign x (op cdr) (reg x))
      (goto (label append-start))
    after-append-cdr
      (restore x)
      (restore continue)
      (assign tmp (op car) (reg x))
      (assign result (op cons) (reg tmp) (reg result))
      (goto (reg continue))
    null-x
      (assign result (reg y))
      (goto (reg continue))
    append-done)))
