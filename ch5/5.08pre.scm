(define amb-label
  (make-machine
    '(a)
    '()
    '(start
       (goto (label here))
     here
       (assign a (const 3))
       (goto (label there))
     here
       (assign a (const 4))
       (goto (label there))
     there)))
