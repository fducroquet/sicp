(define (get-breakpoint-instruction label n)
  (let ((label-target (lookup-label labels label)))
    (list-ref label-target (- n 1))))

(define (set-breakpoint label n)
  (let ((breakpoint-inst (get-breakpoint-instruction label n)))
    (set-instruction-breakpoint! breakpoint-inst (make-breakpoint label n))))

(define (cancel-breakpoint label n)
  (let ((breakpoint-inst (get-breakpoint-instruction label n)))
    (cancel-breakpoint! breakpoint-inst)))

(define (cancel-all-breakpoints)
  (for-each cancel-breakpoint! the-instruction-sequence))

(define (execute check-breakpoint)
  (let ((insts (get-contents pc)))
    (if (null? insts)
      'done
      (let ((next (car insts)))
        (if (and check-breakpoint (breakpoint? next))
          (break next)
          (begin
            (set! instruction-count (+ 1 instruction-count))
            (if trace
              (print-inst next))
            ((instruction-execution-proc next))
            (execute #t)))))))

(define (break inst)
  (let ((breakpoint (instruction-breakpoint inst)))
    (display "Breakpoint reached, label ")
    (display (breakpoint-label breakpoint))
    (display ", offset ")
    (display (breakpoint-offset breakpoint))
    (newline)))

(define (proceed)
  (execute #f))
