(define (type-tag datum)
  (cond ((and (integer? datum)
              (exact? datum)) 'integer)
        ((real? datum) 'real)
        ((pair? datum) (car datum))
        (else
          (error "Bad tagged datum -- TYPE-TAG" datum))))

(define (attach-tag type-tag contents)
  (if (or (eq? 'integer type-tag)
          (eq? 'real type-tag))
    contents
    (cons type-tag contents)))

(define (install-number-package type)
  (define (tag x)
    (attach-tag type x))
  (put 'add (list type type)
       (lambda (x y) (tag (+ x y))))
  (put 'sub (list type type)
       (lambda (x y) (tag (- x y))))
  (put 'mul (list type type)
       (lambda (x y) (tag (* x y))))
  (put 'div (list type type)
       (lambda (x y) (tag (/ x y))))
  (put 'equ? (list type type) =)
  (put '=zero? (list type)
       (lambda (x) (= x 0)))
  (put 'make type
       (lambda (x) (tag x)))
  'done)

(install-number-package 'integer)
(install-number-package 'real)

(define (make-integer n)
  ((get 'make 'integer) n))
(define (make-real n)
  ((get 'make 'real) n))
