(define (negate operands frame-stream)
  (define (keep? frame)
    (stream-null? (qeval (negated-query operands)
                         (singleton-stream frame))))
  (simple-stream-flatmap
    (lambda (frame)
      (filter-or-add-promise frame (negated-query operands) keep?))
    frame-stream))

(put 'not 'qeval negate)

(define (lisp-value call frame-stream)
  (define (keep? frame)
    (execute (instantiate
               call
               frame
               (lambda (v f)
                 (error "Unknown pat var -- LISP-VALUE" v)))))
  (simple-stream-flatmap
    (lambda (frame)
      (filter-or-add-promise frame call keep?))
    frame-stream))

(put 'lisp-value 'qeval lisp-value)

(define (filter-or-add-promise frame query keep?)
  (cond ((has-unbound-var? query frame)
         (singleton-stream (add-promise frame query keep?)))
        ((keep? frame)
         (singleton-stream frame))
        (else the-empty-stream)))

(define (conjoin conjuncts frame-stream)
  (if (empty-conjunction? conjuncts)
    frame-stream
    (conjoin (rest-conjuncts conjuncts)
             (stream-filter keep? (qeval (first-conjunct conjuncts)
                                         frame-stream)))))

(define (keep? frame)
  (define (iter bindings)
    (if (null? bindings)
      #t
      (let ((binding (car bindings)))
        (if (eq? (binding-variable binding) '*promise*)
          (let ((promise (binding-value binding)))
            (if (has-unbound-var? (promise-query promise) frame)
              (iter (cdr bindings))
              (and ((promise-proc promise) frame)
                   (iter (cdr bindings)))))
          (iter (cdr bindings))))))
  (iter frame))

(define (add-promise frame query promise)
  (extend '*promise* (make-promise query promise) frame))

(define (make-promise query promise)
  (cons query promise))

(define (promise-query promise) (car promise))
(define (promise-proc promise) (cdr promise))
