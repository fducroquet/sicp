(define (repeated f n)
  (define (iter count result)
    (if (= count n)
      result 
      (iter (+ count 1)
            (compose f result))))
  (iter 1 f))
