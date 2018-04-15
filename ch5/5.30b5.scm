(define (association-list? a)
  (or (null? a)
      (and (pair? a)
           (pair? (car a))
           (association-list? (cdr a)))))
