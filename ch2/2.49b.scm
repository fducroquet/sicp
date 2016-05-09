(define cross
  (let ((vbl (make-vect 0 0))
        (vbr (make-vect 1 0))
        (vtr (make-vect 1 1))
        (vtl (make-vect 0 1)))
    (segments->painter
      (list (make-segment vbl vtr)
            (make-segment vtl vbr)))))
