(define (triple-sum n s)
  (define (equal-sum? triple)
    (= (accumulate + 0 triple)
       s))
  (filter equal-sum?
          (flatmap
            (lambda (pair)
              (map (lambda (i)
                     (cons i pair))
                   (enumerate-interval (+ (car pair) 1) n)))
            (unique-pairs n))))
