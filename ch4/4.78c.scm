(define (simple-query query-pattern frame)
  (amb (find-assertions query-pattern frame)
       (apply-rules query-pattern frame)))

(define (conjoin conjuncts frame)
  (if (empty-conjunction? conjuncts)
    frame
    (conjoin (rest-conjuncts conjuncts)
             (qeval (first-conjunct conjuncts)
                    frame))))

(define (disjoin disjuncts frame)
  (require (not (empty-disjunction? disjuncts)))
  (ramb (qeval (first-disjunct disjuncts) frame)
        (disjoin (rest-disjuncts disjuncts) frame)))

(define (negate operands frame)
  (require-fail (qeval (negated-query operands) frame))
  frame)

(define (lisp-value call frame)
  (require (execute
             (instantiate
               call
               frame
               (lambda (v f)
                 (error "Unknown pat var -- LISP-VALUE" v)))))
  frame)
