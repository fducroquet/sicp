(define new-syntax
  (make-machine
    '(a b c)
    (list (list '+ +) (list 'display display) (list '= =))
    '((assign a (const 2))
      (assign b (const 3))
      (assign a op + (reg a) (reg b))
      (assign c (reg b))
      (test op = (reg a) (const 5))
      (branch (label eq-5))
      (perform op display (const "not 5"))
    eq-5
      (perform op display (const "3")))))
