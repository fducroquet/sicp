(define (sum? x)
  (memq '+ x))

(define (product? x)
  (and (not (sum? x)) (memq '* x)))

(define (elt-or-list l)
  (if (= 1 (length l))
    (car l)
    l))

(define (take-until l elt)
  (if (or (null? l) (eq? (car l) elt))
    '()
    (cons (car l) (take-until (cdr l) elt))))

(define (intersperse l sep)
  (if (<= (length l) 1)
    l
    (append (list (car l) sep) (intersperse (cdr l) sep))))

(define (addend s)
  (elt-or-list (take-until s '+)))

(define (multiplier p)
  (elt-or-list (take-until p '*)))

(define (augend s)
  (elt-or-list (cdr (memq '+ s))))

(define (multiplicand p)
  (elt-or-list (cdr (memq '* p))))

(define (make-sum . elts)
  (let ((nb (apply + (filter number? elts)))
        (exps (filter (lambda (x)
                        (not (number? x)))
                      elts)))
    (cond ((null? exps) nb)
          ((= nb 0)
           (elt-or-list (intersperse exps '+)))
          (else (intersperse (cons nb exps) '+)))))

; TODO: Parenthèses
(define (make-product . elts)
  (let ((nb (apply * (filter number? elts)))
        (exps (filter (lambda (x)
                        (not (number? x)))
                      elts)))
    (cond ((null? exps) nb)
          ((= nb 0)
           0)
          ((= nb 1)
           (elt-or-list (intersperse exps '*)))
          (else (intersperse (cons nb exps) '*)))))
