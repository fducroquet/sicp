(define pairs-sum-order
  (weighted-pairs integers
                  integers
                  (lambda (pair)
                    (+ (car pair) (cadr pair)))))
