(define (get-coeff-by-degree p degree)
  (get-coeff-by-degree-terms (term-list p) degree))

(define (get-coeff-by-degree-terms term-list degree)
  (cond ((empty-termlist? term-list) 0)
        ((= (order (first-term term-list)) degree)
         (coeff (first-term term-list)))
        (else
          (get-coeff-by-degree-terms (rest-terms term-list) degree))))

(define (degree p)
  (degree-terms (term-list p)))

(define (degree-terms term-list)
  (if (empty-termlist? term-list)
    0
    (order (first-term term-list))))

(define (equ-term-lists? L1 L2)
  (cond ((and (empty-termlist? L1) (empty-termlist? L2))
         true)
        ((or (empty-termlist? L1) (empty-termlist? L2))
         false)
        (else
          (let ((t1 (first-term L1))
                (t2 (first-term L2)))
            (cond ((> (order t1) (order t2))
                   (and (=zero? (coeff t1))
                        (equ-term-lists? (rest-terms L1) L2)))
                  ((< (order t1) (order t2))
                   (and (=zero? (coeff t2))
                        (equ-term-lists? L1 (rest-terms L2))))
                  (else
                    (and (equ? (coeff t1) (coeff t2))
                         (equ-term-lists? (rest-terms L1) (rest-terms L2)))))))))

(put 'project '(polynomial)
     (lambda (p)
       (let ((c0 (get-coeff-by-degree p 0)))
         (if (eq? (type-tag c0) 'polynomial)
           (project c0)
           c0))))

(put 'raise '(complex)
     (lambda (z)
       (make-polynomial 'x (adjoin-term (make-term 0 (drop (attach-tag 'complex z)))
                                        (make-empty-termlist 'dense)))))

(put 'equ? '(polynomial polynomial)
     (lambda (p1 p2)
       (if (and (not (eq? (variable p1) (variable p2)))
                (or (> (degree p1) 0) (> (degree p2) 0)))
         false
         (let ((L1 (term-list p1))
               (L2 (term-list p2)))
           (equ-term-lists? L1 L2)))))
