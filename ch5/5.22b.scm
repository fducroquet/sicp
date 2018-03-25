(define append!-machine
  (make-machine
    ; Arguments in x and y (x must not be empty), result in x.
    '(x y tmp curr-pair)
    (list (list 'car car) (list 'cdr cdr) (list 'set-cdr! set-cdr!)
          (list 'cons cons) (list 'null? null?))
    '((assign curr-pair (reg x))
    last-pair-loop
      (assign tmp (op cdr) (reg curr-pair))
      (test (op null?) (reg tmp))
      (branch (label last-pair-found))
      (assign curr-pair (op cdr) (reg curr-pair))
      (goto (label last-pair-loop))
    last-pair-found
      (perform (op set-cdr!) (reg curr-pair) (reg y)))))
