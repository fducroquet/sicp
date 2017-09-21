(define (ln2-summands n)
  (cons-stream (/ 1.0 n)
               (stream-map - (ln2-summands (+ n 1)))))

(define ln2-stream (partial-sums (ln2-summands 1)))

(define ln2-stream-acc (euler-transform ln2-stream))

(define ln2-stream-acc2 (accelerated-sequence euler-transform ln2-stream))
