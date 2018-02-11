(define (execute)
  (let ((insts (get-contents pc)))
    (if (null? insts)
      'done
      (begin
        (set! instruction-count (+ 1 instruction-count))
        ((instruction-execution-proc (car insts)))
        (execute)))))
