(define (cond-=>-clause? clause)
  (eq? (cadr clause) '=>))

(define (cond-recipient clause)
  (cddr clause))

(define (cond-actions clause)
  (if (cond-=>-clause? clause)
    (list (cond-recipient clause)
          (cond-predicate clause)))
  (cdr clause))
