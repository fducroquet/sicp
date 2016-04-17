(define (same-parity . numbers)
  (define (iter rest)
    (cond ((null? rest)
           '())
          ((even? (- (car numbers) (car rest)))
           (cons (car rest) (iter (cdr rest))))
          (else
            (iter (cdr rest)))))
  (iter numbers))
