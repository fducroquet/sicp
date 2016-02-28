(define (filtered-accumulate filter combiner null-value term a next b)
  (if (> a b)
    null-value
    (combiner (if (filter a)
		(term a)
		null-value)
              (filtered-accumulate filter
				   combiner
				   null-value
				   term
				   (next a)
				   next
				   b))))
