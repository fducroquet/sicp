(define (find-variable var c-env)
  (define (find-disp disp frame)
    (cond ((null? frame) -1)
          ((eq? (car frame) var) disp)
          (else (find-disp (+ disp 1) (cdr frame)))))

  (define (find-address frame-num c-env)
    (if (null? c-env)
      'not-found
      (let ((disp (find-disp 0 (first-frame c-env))))
        (if (= disp -1)
          (find-address (+ frame-num 1) (enclosing-environment c-env))
          (make-lexical-address frame-num disp)))))

  (find-address 0 c-env))
