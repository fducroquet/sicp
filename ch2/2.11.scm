(define (mul-interval x y)
  (let ((a (lower-bound x))
        (b (upper-bound x))
        (c (lower-bound y))
        (d (upper-bound y)))
    (cond ((>= a 0)
           (cond ((<= d 0)
                  (make-interval (* b c) (* a c)))
                 ((>= c 0)
                  (make-interval (* a c) (* b d)))
                 (else
                  (make-interval (* b c) (* b d)))))
          ((<= b 0)
           (cond ((<= d 0)
                  (make-interval (* b d) (* a c)))
                 ((>= c 0)
                  (make-interval (* a d) (* b c)))
                 (else
                   (make-interval (* a d) (* a c)))))
          (else
            (cond ((<= d 0)
                   (make-interval (* b d) (* a d)))
                  ((>= c 0)
                   (make-interval (* a d) (* b d)))
                  (else
                    (make-interval
                      (min (* a d) (* b c))
                      (max (* a c) (* b d)))))))))
