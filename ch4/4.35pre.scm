(run-in-interpreter
  '(define (smallest-divisor n)
     (find-divisor n 2))

  '(define (square x) (* x x))

  '(define (find-divisor n test-divisor)
     (cond ((> (square test-divisor)  n) n)
           ((divides? test-divisor n) test-divisor)
           (else (find-divisor n (+ test-divisor 1)))))

  '(define (divides? a b)
     (= (remainder b a) 0))

  '(define (prime? n)
     (= n (smallest-divisor n)))

  '(define (prime-sum-pair list1 list2)
     (let ((a (an-element-of list1))
           (b (an-element-of list2)))
       (require (prime? (+ a b)))
       (list a b)))

  '(define (require p)
     (if (not p) (amb)))

  '(define (an-element-of items)
     (require (not (null? items)))
     (amb (car items) (an-element-of (cdr items))))

  '(define (an-integer-starting-from n)
     (amb n (an-integer-starting-from (+ n 1)))))
