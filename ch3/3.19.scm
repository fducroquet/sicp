(define (contains-cycle? x)
  (define (helper x x2)
    (cond ((eq? x x2) #t)
          ((or (null? x2) (null? (cdr x2))) #f)
          (else (helper (cdr x) (cddr x2)))))
  (if (null? x)
    #f
    (helper x (cdr x))))
