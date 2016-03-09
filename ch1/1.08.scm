(define (cube-iter guess x)
  (define new-guess (improve guess x))
  (if (good-enough? guess new-guess)
      guess
      (cube-iter new-guess
                 x)))

(define (improve guess x)
  (/ (+ (/ x (square guess))
	(* 2 guess))
     3))

(define (cuberoot x)
  ; Call cube-iter only with positive values because otherwise
  ; (improve guess x) can return 0, e.g. with (improve-guess 1.0 -2)
  (if (>= x 0)
    (cube-iter 1.0 x)
    (- (cube-iter 1.0 (- x)))))
