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
