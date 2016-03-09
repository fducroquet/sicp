(define (start-prime-test n start-time)
  (if (fast-prime? n 100)
    (report-prime (- (runtime) start-time))))
