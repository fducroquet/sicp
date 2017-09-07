(define (contains-cycle? x)
  (define (helper x seen)
    (cond ((null? x) #f)
          ((memq x seen) #t)
          (else
            (helper (cdr x) (cons x seen)))))
  (helper x '()))
