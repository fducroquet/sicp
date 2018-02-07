(define label-arg
  (make-machine
    '(a)
    (list (list 'string-append string-append))
    '(start
       (assign a (const "a"))
       (assign a (op string-append) (reg a) (label start)))))
