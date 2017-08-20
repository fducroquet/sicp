(define (add-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
    (make-polynomial (variable p1)
                     (add-terms (term-list p1)
                                (term-list p2)))
    (let ((same-var (make-same-var p1 p2)))
      (add (car same-var) (cdr same-var)))))

(define (mul-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
    (make-polynomial (variable p1)
                     (mul-terms (term-list p1)
                                (term-list p2)))
    (let ((same-var (make-same-var p1 p2)))
      (mul (car same-var) (cdr same-var)))))

(define (neg-poly p)
  (make-polynomial (variable p)
                   (neg-terms (term-list p))))

(define (div-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
    (let ((div-result (div-terms (term-list p1)
                                 (term-list p2))))
      (list (make-polynomial (variable p1) (car div-result))
            (make-polynomial (variable p1) (cadr div-result))))
    (let ((same-var (make-same-var p1 p2)))
      (div (car same-var) (cdr same-var)))))

(put 'add '(polynomial polynomial)
     (lambda (p1 p2) (add-poly p1 p2)))
(put 'mul '(polynomial polynomial)
     (lambda (p1 p2) (mul-poly p1 p2)))
(put 'neg '(polynomial)
     (lambda (p) (neg-poly p)))
(put 'sub '(polynomial polynomial)
     (lambda (p1 p2) (add-poly p1 (contents (neg-poly p2)))))
(put 'div '(polynomial polynomial)
     (lambda (p1 p2) (div-poly p1 p2)))
