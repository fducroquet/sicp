(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (non-trivial-root-test (expmod base (/ exp 2) m) m))
        (else
          (remainder (* base (expmod base (- exp 1) m))
                     m))))

(define (non-trivial-root-test a n)
  (let ((rm (remainder a n))
        (rm2 (remainder (square a) n)))
    (if (and (not (= rm 1))
             (not (= rm (- n 1)))
             (= rm2 1))
      0
      rm2)))

(define (miller-rabin-test n)
  (define (try-it a)
    (= (expmod a (- n 1) n) 1))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) #t)
	((miller-rabin-test n) (fast-prime? n (- times 1)))
	(else #f)))
