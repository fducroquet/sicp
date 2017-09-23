(define (square-sum pair)
    (+ (square (car pair)) (square (cadr pair))))

(define three-square-sums
  (stream-map (lambda (dec-list)
                (cons (square-sum (car dec-list)) dec-list))
              (stream-filter
                (lambda (group)
                  (>= (length group) 3))
                (group-by (weighted-pairs integers
                                          integers
                                          square-sum)
                          (lambda (p1 p2)
                            (= (square-sum p1) (square-sum p2)))))))
