(define (make-center-percent c p)
  (let ((width (* c (/ p 100))))
    (make-interval (- c width) (+ c width))))

(define (percent i)
  (* (/ (width i) (center i))
     100))
