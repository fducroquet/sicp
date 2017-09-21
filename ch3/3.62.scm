(define (div-series num denom)
  (if (= 0 (stream-car denom))
    (error "Denominator has a zero constant term -- DIV-SERIES.")
    (let ((c (/ 1 (stream-car denom))))
      (scale-stream (mul-series num (invert-unit-series (scale-stream denom c)))
                    c))))

(define tan-series (div-series sine-series cosine-series))
