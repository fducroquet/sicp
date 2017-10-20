(run-in-interpreter
  '(define underlying-cons cons)
  '(define underlying-car car)
  '(define underlying-cdr cdr)

  '(define (cons x y)
     (underlying-cons 'lazy-pair (lambda (m) (m x y))))

  '(define (lazy-pair? x)
     (and (pair? x)
          (eq? (underlying-car x) 'lazy-pair)))

  '(define (car z)
     (if (lazy-pair? z)
       ((underlying-cdr z) (lambda (p q) p))
       (error "Not a pair -- CAR" z)))

  '(define (cdr z)
     (if (lazy-pair? z)
       ((underlying-cdr z) (lambda (p q) q))
       (error "Not a pair -- CDR" z)))

  '(define *max-depth* 5)
  '(define *max-breadth* 20)

  '(define (lazy-struct->pairs l)
     (define (rec items depth breadth)
       (cond ((not (lazy-pair? items)) items)
             ((or (< depth 0) (= breadth 0))
              (underlying-cons '<...> '()))
             (else
               (underlying-cons (rec (car items) (- depth 1) *max-breadth*)
                                (rec (cdr items) depth (- breadth 1))))))
     (rec l *max-depth* *max-breadth*)))
