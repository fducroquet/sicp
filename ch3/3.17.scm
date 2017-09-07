(define (count-pairs x)
  (define (find-unique-pairs x visited)
    (if (or (not (pair? x))
            (memq x visited))
      visited
      (find-unique-pairs (car x)
                         (find-unique-pairs (cdr x) (cons x visited)))))
  (length (find-unique-pairs x '())))
