(define (div-interval x y)
  (let ((low-y (lower-bound y))
	(up-y (upper-bound y)))
    (if (and (<= low-y 0) (>= up-y 0))
      (error "Division by zero")
      (mul-interval x
		    (make-interval (/ 1.0 (upper-bound y))
				   (/ 1.0 (lower-bound y)))))))
