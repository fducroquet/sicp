(define (no-more-clauses? clauses)
  (null? clauses))

(define (first-clause clauses)
  (car clauses))

(define (rest-clauses clauses)
  (cdr clauses))

(define (last-clause? clauses)
  (null? (cdr clauses)))
