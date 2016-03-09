(define (f n)
  (define (iter k fk fk-1 fk-2)
    (if (= k n)
      fk
      (iter (+ k 1)
	    (+ fk
	       (* 2 fk-1)
	       (* 3 fk-2))
	    fk
	    fk-1)))
  (if (< n 3)
    n
    (iter 2 2 1 0)))
