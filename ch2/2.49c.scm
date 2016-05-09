(define outline
  (let ((v1 (make-vect 0.5 0))
        (v2 (make-vect 1 0.5))
        (v3 (make-vect 0.5 1))
        (v4 (make-vect 0 0.5)))
    (segments->painter
      (list (make-segment v1 v2)
            (make-segment v2 v3)
            (make-segment v3 v4)
            (make-segment v4 v1)))))
