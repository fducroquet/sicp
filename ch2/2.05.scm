(define (cons a b)
  (* (expt 2 a)
     (expt 3 b)))

(define (iter power curr base)
  (if (not (= (remainder curr base) 0))
    power
    (iter (+ power 1)
          (/ curr base)
          base)))

(define (car z)
  (iter 0 z 2))

(define (cdr z)
  (iter 0 z 3))
