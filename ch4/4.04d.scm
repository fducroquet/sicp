(define (and->if exp)
  (expand-and (and-tests exp)))

(define (or->if exp)
  (expand-or (or-tests exp)))

(define (expand-or exps)
  (if (null? exps)
    'false
    (let ((first (car exps))
          (rest (cdr exps)))
      (make-if first
               first
               (expand-or rest)))))

(define (expand-and exps)
  (cond ((null? exps) 'true)
        ((last-exp? exps) (car exps))
        (else
          (let ((first (car exps))
                (rest (cdr exps)))
            (make-if first
                     (expand-and rest)
                     'false)))))
