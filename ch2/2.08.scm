(define (sub-interval x y)
  (add-interval x
		(make-interval (- (upper-bound y))
			       (- (lower-bound y)))))
