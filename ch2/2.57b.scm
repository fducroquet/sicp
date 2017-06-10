(define (augend s)
  (apply make-sum (cddr s)))

(define (multiplicand p)
  (apply make-product (cddr p)))

(define (make-sum . elts)
  (let ((nb (apply + (filter number? elts)))
        (exps (filter (lambda (x)
                        (not (number? x)))
                      elts)))
    (cond ((null? exps) nb)
          ((= nb 0)
           (if (null? (cdr exps))
             (car exps)
             (cons '+ exps)))
          (else (cons '+ (cons nb exps))))))

(define (make-product . elts)
  (let ((nb (apply * (filter number? elts)))
        (exps (filter (lambda (x)
                        (not (number? x)))
                      elts)))
    (cond ((null? exps) nb)
          ((= nb 0)
           0)
          ((= nb 1)
           (if (null? (cdr exps))
             (car exps)
             (cons '* exps)))
          (else (cons '* (cons nb exps))))))