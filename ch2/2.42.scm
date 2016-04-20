(define (queens board-size)
  (define empty-board '())

  (define (safe? positions)
    (define (iter delta-col rest-cols)
      (if (null? rest-cols)
        #t
        (let ((new-queen-pos (car positions))
              (col-pos (car rest-cols)))
          (and (not (= new-queen-pos col-pos))
               (not (= new-queen-pos (+ col-pos delta-col)))
               (not (= new-queen-pos (- col-pos delta-col)))
               (iter (+ delta-col 1) (cdr rest-cols))))))
    (iter 1 (cdr positions)))

  (define (adjoin-position new-row rest-of-queens)
    (cons new-row rest-of-queens))

  (define (queens-cols k)
    (if (= k 0)
      (list empty-board)
      (filter
        (lambda (positions) (safe? positions))
        (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queens-cols (- k 1))))))

  (queens-cols board-size))
