(define (count-leaves tree)
  (accumulate +
              0
              (map (lambda (subtree)
                     (if (pair? subtree)
                       (count-leaves subtree)
                       1))
                   tree)))
