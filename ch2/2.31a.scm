(define (tree-map f tree)
  (cond ((null? tree) '())
        ((not (pair? tree)) (f tree))
        (else
          (cons (tree-map f (car tree))
                (tree-map f (cdr tree))))))
