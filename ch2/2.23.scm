(define (for-each proc items)
  (if (null? items)
    #t
    (begin
      (proc (car items))
      (for-each proc (cdr items)))))
