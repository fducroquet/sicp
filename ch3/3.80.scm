(define (RLC R L C dt)
  (lambda (vC0 iL0)
    (define vC (integral (delay (scale-stream iL (- (/ 1 C)))) iL0 dt))
    (define iL (integral (delay (add-streams (scale-stream vC (/ 1 L))
                                             (scale-stream iL (- (/ R L)))))
                                vC0
                                dt))
    (cons vC iL)))

(define RLC1 ((RLC 1 1 .2 .1) 10 0))
(define vC (car RLC1))
(define iL (cdr RLC1))
