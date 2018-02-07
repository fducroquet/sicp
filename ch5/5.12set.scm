(define (element-of-set? x set smaller?)
  (cond ((null? set) #f)
        ((equal? (car set) x) #t)
        ((smaller? x (car set)) #t)
        (else
          (element-of-set? x (cdr set) smaller?))))

(define (adjoin-set x set smaller?)
  (if (null? set)
    (list x)
    (let ((first (car set)))
          (cond ((equal? x first) set)
                ((smaller? x first) (cons x set))
                (else (cons first (adjoin-set x (cdr set) smaller?)))))))

(define (smaller? obj1 obj2)
  (string-ci<? (object->string obj1) (object->string obj2)))
