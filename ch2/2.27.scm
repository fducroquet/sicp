(define (deep-reverse items)
  (define (iter items result)
    (cond ((null? items)
           result)
          ((not (pair? items))
           items)
          (else
            (iter (cdr items) (cons (reverse (car items)) result)))))
  (iter items '()))
