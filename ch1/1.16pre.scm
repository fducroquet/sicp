(define (expt b n)
  (if (= n 0)
    1
    (* b (expt b (- n 1)))))

(define (expt b n)
  (expt-iter b n 1))

(define (expt-iter b counter product)
  (if (= counter 0)
    product
    (expt-iter b
	       (- counter 1)
	       (* b product))))

(define (fast-expt b n)
  (cond ((= n 0) 1)
	((even? n) (fast-expt (square b) (/ n 2)))
	(else (* b (fast-expt b (- n 1))))))
