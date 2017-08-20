(define (make-monom vars coeff)
  (list vars coeff))
(define (vars monom)
  (if (null? monom) '()
    (car monom)))
(define (monom-coeff monom)
  (cadr monom))
(define (make-var-power var power)
  (list var power))
(define (get-var var-power)
  (car var-power))
(define (var-degree var-power)
  (cadr var-power))
(define (empty-var-list) '())

; Adds a list (var power) to the ordered list of variables defining a monom.
; e.g. (add-var (y 2) ((x 1) (y 1) (z 2))
; returns ((x 1) (y 3) (z 2))
(define (add-var var-power vars-list)
  (if (null? vars-list)
    (list var-power)
    (let* ((var (get-var var-power))
           (first (car vars-list))
           (first-var (get-var first))
           (var-name (symbol->string var))
           (first-var-name (symbol->string first-var)))
      (cond ((string<? first-var-name var-name)
             (cons first (add-var var-power (cdr vars-list))))
            ((string=? first-var-name var-name)
             (cons (make-var-power var
                                   (+ (var-degree first) (var-degree var-power)))
                   (cdr vars-list)))
            (else
              (cons var-power vars-list)) ))))

;; Merges two ordered lists of monoms.
(define (merge-monoms monoms1 monoms2)
  (cond ((null? monoms1) monoms2)
        ((null? monoms2) monoms1)
        (else
          (let* ((monom1 (car monoms1))
                 (monom2 (car monoms2))
                 (comp (compare-var-lists (vars monom1) (vars monom2))))
            (cond ((= 1 comp)
                   (cons (car monoms1)
                         (merge-monoms (cdr monoms1) monoms2)))
                  ((= -1 comp)
                   (cons (car monoms2)
                         (merge-monoms monoms1 (cdr monoms2))))
                  ((= 0 comp)
                   (let ((coeff (add (monom-coeff monom1) (monom-coeff monom2))))
                     (if (=zero? coeff)
                       (merge-monoms (cdr monoms1)
                                     (cdr monoms2))
                       (cons (make-monom (vars monom1)
                                         coeff)
                             (merge-monoms (cdr monoms1)
                                           (cdr monoms2)))))))))))

; 1 if var-list1 < var-list2
; 0 if var-list1 = var-list2
; -1 if var-list1 > var-list2
(define (compare-var-lists var-list1 var-list2)
  (cond ((and (null? var-list1) (null? var-list2))
         0)
        ((null? var-list1) -1)
        ((null? var-list2) 1)
        (else
          (let ((v1 (symbol->string (get-var (car var-list1))))
                (v2 (symbol->string (get-var (car var-list2)))))
            (cond ((string<? v1 v2) 1)
                  ((string>? v1 v2) -1)
                  (else
                    (let ((o1 (var-degree (car var-list1)))
                          (o2 (var-degree (car var-list2))))
                      (cond ((< o1 o2) -1)
                            ((> o1 o2) 1)
                            (else
                              (compare-var-lists (cdr var-list1) (cdr var-list2))))))))) ))

; Transforms a polynomial into a list of monoms, e.g.
; (polynomial x dense (polynomial y dense 2 3) 0 2)
; becomes:
; ((((x 2) (y 1)) 2)
; (((x 2)) 3)
; (() 2))
(define (poly->monoms p)
  (let ((var (variable p))
        (terms (term-list p)))
    (if (empty-termlist? terms)
      '()
      (let* ((t1 (first-term terms))
             (o (order t1))
             (c (coeff t1))
             (var-power (make-var-power var o))
             (rest-monoms (poly->monoms (make-poly var (rest-terms terms)))))
        (cond ((eq? 'polynomial (type-tag c))
               (if (= o 0)
                 (merge-monoms (poly->monoms (contents c))
                               rest-monoms)
                 (merge-monoms (map (lambda (monom)
                                      (make-monom (add-var var-power (vars monom))
                                                  (monom-coeff monom)))
                                    (poly->monoms (contents c)))
                               rest-monoms)))
              ((=zero? c) rest-monoms)
              ((= o 0)
               (merge-monoms
                 (list (make-monom (empty-var-list) c))
                 rest-monoms))
              (else
                (merge-monoms
                  (list (make-monom (add-var var-power (empty-var-list)) c))
                  rest-monoms)))))))

; Assumes that monoms is a non-empty list of monoms and var is it’s main 
; variable. Returns the order of var in the first monom.
(define (order-var var monoms)
  (let ((var-list (vars (car monoms))))
    (if (or (null? var-list)
            (not (eq? (get-var (car var-list)) var)))
      0
      (var-degree (car var-list)))))

(define (build-poly var type monoms)
  ; Returns a pair with:
  ; - the coefficient of the term of degree o in the polynomial to build;
  ; - the remaining monoms.
  (define (first-coeff o monoms)
    (define (first-coeff* monoms)
      (cond ((null? monoms)
             (cons '() '()))
            ((= o 0)
             (cons monoms '()))
            (else
              (let* ((o1 (order-var var monoms)))
                (if (< o1 o)
                  (cons '() monoms)
                  (let ((first (car monoms))
                        (rest (first-coeff* (cdr monoms))))
                    (cons (cons (make-monom (cdr (vars first))
                                            (monom-coeff first))
                                (car rest))
                          (cdr rest))))))))
    (let ((monom-list (first-coeff* monoms)))
      (cons (monoms->poly type (car monom-list))
            (cdr monom-list))))

  (if (null? monoms)
    (make-polynomial var (make-empty-termlist type))
    (let* ((o (order-var var monoms))
           (coeff-and-rest (first-coeff o monoms)))
      (make-polynomial var
                       (adjoin-term (make-term o (car coeff-and-rest))
                                    (term-list (contents (build-poly var type (cdr coeff-and-rest)))))))))

; Transforms a list of monoms into a polynomial or tagged data of a lower type.
(define (monoms->poly type monoms)
  (if (null? monoms)
    0
    (let* ((first (car monoms))
           (var-list (vars first)))
      (if (null? var-list)
        ; The list of monoms can have at most one monom with only a constant and 
        ; no variables, so return it.
        (monom-coeff first)
        (let ((main-var (get-var (car var-list))))
          (build-poly main-var type monoms))))))

(define (reorder p)
  (monoms->poly (type-tag (term-list p))
                (poly->monoms p)))

(define (make-same-var p1 p2)
  (let* ((p1* (reorder p1))
         (p2* (reorder p2))
         (t1 (type-tag p1*))
         (t2 (type-tag p2*)))
    (cond ((and (not (eq? 'polynomial t1))
                (not (eq? 'polynomial t2)))
           (cons p1* p2*))
          ((not (eq? 'polynomial t1))
           (cons (make-polynomial (variable (contents p2*))
                                  (adjoin-term (make-term 0 p1*)
                                               (make-empty-termlist 'sparse)))
                 p2*))
          ((or (not (eq? 'polynomial t2))
               (not (same-variable? (variable (contents p1*)) (variable (contents p2*)))))
           (cons p1*
                 (make-polynomial (variable (contents p1*))
                                  (adjoin-term (make-term 0 p2*)
                                               (make-empty-termlist 'sparse)))))
          (else
            (cons p1* p2*)))))
