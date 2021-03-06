(define (filtered-accumulate filter combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
      result
      (iter (next a)
	    (combiner (if (filter a)
			(term a)
			null-value)
		      result))))
  (iter a null-value))
