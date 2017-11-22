(define (find-assertions pattern frame)
  (pattern-match pattern (an-element-of (fetch-assertions pattern)) frame))

(define (pattern-match pat dat frame)
  (cond ((equal? pat dat) frame)
        ((var? pat) (extend-if-consistent pat dat frame))
        ((and (pair? pat) (pair? dat))
         (pattern-match (cdr pat)
                        (cdr dat)
                        (pattern-match (car pat)
                                       (car dat)
                                       frame)))
        (else (amb))))

(define (apply-rules pattern frame)
  (apply-a-rule (an-element-of (fetch-rules pattern)) pattern frame))

(define (apply-a-rule rule query-pattern query-frame)
  (let ((clean-rule (rename-variables-in rule)))
    (qeval (rule-body clean-rule)
           (unify-match query-pattern
                        (conclusion clean-rule)
                        query-frame))))

(define (unify-match p1 p2 frame)
  (cond ((equal? p1 p2) frame)
        ((var? p1) (extend-if-possible p1 p2 frame))
        ((var? p2) (extend-if-possible p2 p1 frame))
        ((and (pair? p1) (pair? p2))
         (unify-match (cdr p1)
                      (cdr p2)
                      (unify-match (car p1)
                                   (car p2)
                                   frame)))
        (else (amb))))

(define (extend-if-possible var val frame)
  (let ((binding (binding-in-frame var frame)))
    (cond (binding
            (unify-match (binding-value binding) val frame))
          ((var? val)
           (let ((binding (binding-in-frame val frame)))
             (if binding
               (unify-match var (binding-value binding) frame)
               (extend var val frame))))
          (else
            (require (not (depends-on? val var frame)))
            (extend var val frame)))))
