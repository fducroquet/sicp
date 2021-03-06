(define (search-for-primes start end)
  (define (iter start)
    (cond ((<= start end)
	   (timed-prime-test start)
	   (iter (+ 2 start)))
	  (else
	    (display "\n"))))
  (if (even? start)
    (iter (+ start 1))
    (iter start)))
