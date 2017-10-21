(run-in-interpreter
  '(define (a-queens-pos board-size)
     (define (safe? positions)
       (define (iter delta-col rest-cols)
         (if (null? rest-cols)
           true
           (let ((new-queen-pos (car positions))
                 (col-pos (car rest-cols)))
             (and (not (= new-queen-pos col-pos))
                  (not (= new-queen-pos (+ col-pos delta-col)))
                  (not (= new-queen-pos (- col-pos delta-col)))
                  (iter (+ delta-col 1) (cdr rest-cols))))))
       (iter 1 (cdr positions)))

     (define (a-queens-cols-pos k)
       (if (= k 0)
         '()
         (let ((prev-cols (a-queens-cols-pos (- k 1)))
               (new-col-pos (an-integer-between 1 board-size)))
           (let ((new-pos (cons new-col-pos prev-cols)))
             (require (safe? new-pos))
             new-pos))))

     (a-queens-cols-pos board-size)))
