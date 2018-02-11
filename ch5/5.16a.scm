(define (execute)
  (let ((insts (get-contents pc)))
    (if (null? insts)
      'done
      (begin
        (set! instruction-count (+ 1 instruction-count))
        (if trace
          (begin
            (display (instruction-text (car insts)))
            (newline)))
        ((instruction-execution-proc (car insts)))
        (execute)))))
