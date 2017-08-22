(define (make-accumulator sum)
  (lambda (x)
    (begin (set! sum (+ sum x))
           sum)))
