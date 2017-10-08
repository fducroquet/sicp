(define fib
  (lambda (n)
    ((lambda (fib)
       (fib fib n))
     (lambda (f k)
       (cond ((= k 0) 0)
             ((= k 1) 1)
             (else
               (+ (f f (- k 1))
                  (f f (- k 2)))))))))
