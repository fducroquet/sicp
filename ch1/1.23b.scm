(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor)  n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (next test-divisor)))))
