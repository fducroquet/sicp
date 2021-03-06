(define (adjoin-term term term-list)
  ((apply-generic 'adjoin-term term-list) term))
(define (first-term term-list)
  (apply-generic 'first-term term-list))
(define (rest-terms term-list)
  (apply-generic 'rest-terms term-list))
(define (empty-termlist? term-list)
  (apply-generic 'empty-termlist? term-list))
(define (make-empty-termlist type)
  ((get 'make type) '()))
(put 'no-drop? 'adjoin-term true)
(put 'no-drop? 'first-term true)
(put 'no-drop? 'rest-terms true)
(put 'no-drop? 'empty-termlist? true)

(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))

(define (install-dense-termlist-package)
  (define (adjoin-term term term-list)
    (cond ((=zero? (coeff term))
           term-list)
          ((= (order term) (length term-list))
           (cons (coeff term) term-list))
          (else
            (adjoin-term term (cons 0 term-list)))))

  (define (first-term term-list)
    (make-term (- (length term-list) 1)
               (car term-list)))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))

  (define (tag tl) (attach-tag 'dense tl))
  (put 'adjoin-term '(dense)
       (lambda (term-list)
         (lambda (term)
           (tag (adjoin-term term term-list)))))
  (put 'first-term '(dense)
       (lambda (term-list) (first-term term-list)))
  (put 'rest-terms '(dense)
       (lambda (term-list) (tag (rest-terms term-list))))
  (put 'empty-termlist? '(dense)
       (lambda (term-list) (empty-termlist? term-list)))
  (put 'make 'dense
       (lambda (termlist) (tag termlist))) )

(define (install-sparse-termlist-package)
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
      term-list
      (cons term term-list)))
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))

  (define (tag tl) (attach-tag 'sparse tl))
  (put 'adjoin-term '(sparse)
       (lambda (term-list)
         (lambda (term)
           (tag (adjoin-term term term-list)))))
  (put 'first-term '(sparse)
       (lambda (term-list) (first-term term-list)))
  (put 'rest-terms '(sparse)
       (lambda (term-list) (tag (rest-terms term-list))))
  (put 'empty-termlist? '(sparse)
       (lambda (term-list) (empty-termlist? term-list)))
  (put 'make 'sparse
       (lambda (termlist) (tag termlist))))

(define (install-polynomial-package)
  ;; ... skipped ...
  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
      (make-empty-termlist (type-tag L1))
      (add-terms (mul-term-by-all-terms (first-term L1) L2)
                 (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
      (make-empty-termlist (type-tag L))
      (let ((t2 (first-term L)))
        (adjoin-term
          (make-term (+ (order t1) (order t2))
                     (mul (coeff t1) (coeff t2)))
          (mul-term-by-all-terms t1 (rest-terms L))))))
  ;; ... skipped ...
  'done)
