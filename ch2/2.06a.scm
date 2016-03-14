(add-1 zero)

(add-1 (lambda (f) (lambda (x) x)))

(lambda (f)
  (lambda (x)
    (f (((lambda (f)
	   (lambda (x) x))
	 f)
	x))))

(lambda (f)
  (lambda (x)
    (f ((lambda (x) x)
	x))))

(lambda (f)
  (lambda (x)
    (f x)))
