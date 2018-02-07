(define restore-order-test
  (make-machine
    '(a b)
    '()
    '((assign a (const 2))
      (assign b (const 3))
      (save a)
      (save b)
      (restore a)
      (restore b))))
