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
  ;; Internal procedures.
  ;; Representation of poly.
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))
  (define (variable? x) (symbol? x))

  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
                 (add-terms (term-list p1)
                            (term-list p2)))
      (error "Polys not in same var -- ADD-POLY"
             (list p1 p2))))
  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
          ((empty-termlist? L2) L1)
          (else
            (let ((t1 (first-term L1)) (t2 (first-term L2)))
              (cond ((> (order t1) (order t2))
                     (adjoin-term t1
                                  (add-terms (rest-terms L1) L2)))
                    ((< (order t1) (order t2))
                     (adjoin-term t2
                                  (add-terms L1 (rest-terms L2))))
                    (else
                      (adjoin-term
                        (make-term (order t1)
                                   (add (coeff t1) (coeff t2)))
                        (add-terms (rest-terms L1)
                                   (rest-terms L2)))))))))

  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
                 (mul-terms (term-list p1)
                            (term-list p2)))
      (error "Polys not in same var -- MUL-POLY"
             (list p1 p2))))
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

  (include "2.87a.scm")
  (include "2.88b.scm")

  ;; Interface to rest of system.
  (define (tag p) (attach-tag 'polynomial p))

  (include "poly-sup.scm")

  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  (put '=zero? '(polynomial)
       (lambda (p) (=zero-terms? (term-list p))))
  (put 'neg '(polynomial)
       (lambda (p) (tag (neg-poly p))))
  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 (neg-poly p2)))))
  'done)

(define (make-polynomial var terms)
  ((get 'make 'polynomial) var terms))
