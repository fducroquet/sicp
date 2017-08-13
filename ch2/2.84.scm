  (define (raise-to-type type arg)
    (let ((t (type-tag arg)))
      (cond ((eq? t type) arg)
            ((higher? type t) (raise-to-type type (raise arg)))
            (else
              (error "Trying to raise an element to a type lower than its own type."
                     (list arg type))))))

(define (highest-type types)
  (define (iter current rest)
    (cond ((null? rest) current)
          ((higher? (car rest) current)
           (iter (car rest) (cdr rest)))
          (else
            (iter current (cdr rest)))))
  (iter (car types) (cdr types)))

(define tower '(integer rational real complex))

(define (higher? t1 t2)
  (let ((m1 (memq t1 tower))
        (m2 (memq t2 tower)))
    (cond ((not m1)
           (error "Type not found -- higher?" t1))
          ((not m2)
           (error "Type not found -- higher?" t2))
          (else
            (< (length m1) (length m2))))))

(define (apply-generic op . args)
  (let* ((type-tags (map type-tag args))
         (proc (get op type-tags)))
    (if proc
      (apply proc (map contents args))
      (let* ((type (highest-type type-tags))
             (raised-args (map (lambda (a)
                                 (raise-to-type type a))
                               args))
             (newproc (get op (map type-tag raised-args))))
        (if newproc
          (apply newproc (map contents raised-args))
          (error "No method for these types"
                 (list op type-tags)))))))
