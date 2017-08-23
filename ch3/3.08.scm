(define f
  (let ((arg 0))
    (lambda (x)
      (let ((prev-arg arg))
        (set! arg x)
        prev-arg))))
