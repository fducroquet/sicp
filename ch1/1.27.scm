(define (pass-fermat? n)
  (define (iter count)
    (cond ((= count 0) #t)
          ((= (expmod count n n) count)
           (iter (- count 1)))
          (else
            #f)))
  (iter (- n 1)))
