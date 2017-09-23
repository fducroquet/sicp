(define (group-by s same-group?)
  (define (helper s group)
    (if (same-group? (stream-car s) (car group))
      (helper (stream-cdr s)
              (cons (stream-car s) group))
      (cons-stream (reverse group)
                   (group-by s same-group?))))
  (helper (stream-cdr s) (list (stream-car s))))

(define (cube x) (* x x x))

(define (cube-sum pair)
  (+ (cube (car pair))
     (cube (cadr pair))))

(define pairs-by-cube-sum (weighted-pairs integers
                                          integers
                                          cube-sum))

(define ramanujan
  (stream-map (lambda (decompositions-list)
                (cons (cube-sum (car decompositions-list))
                      decompositions-list))
              (stream-filter (lambda (list)
                               (> (length list) 1))
                             (group-by pairs-by-cube-sum
                                       (lambda (p1 p2)
                                         (= (cube-sum p1) (cube-sum p2)))))))
