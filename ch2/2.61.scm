(define (adjoin-set x set)
  (if (null? set)
    (list x)
    (let ((first (car set)))
          (cond ((= x first) set)
                ((< x first) (cons x set))
                ((< first x) (cons first (adjoin-set x (cdr set))))))))
