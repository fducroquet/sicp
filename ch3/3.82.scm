(define (randoms-in-range low high)
  (let ((range (- high low)))
    (cons-stream (+ low (* range (random-real)))
                 (randoms-in-range low high))))

(define (estimate-integral P x1 x2 y1 y2)
  (define experiment-stream
    (stream-map P
                (randoms-in-range x1 x2)
                (randoms-in-range y1 y2)))
  (let ((area (* (- x2 x1) (- y2 y1))))
    (scale-stream (monte-carlo experiment-stream 0 0)
                  area)))

; Estimation of Pi by estimating the area of a unit circle.
(define estimate-pi
  (estimate-integral (lambda (x y)
                       (<= (+ (square x) (square y)) 1))
                     -1. 1. -1. 1.))
