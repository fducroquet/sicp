(define *max-depth* 5)
(define *max-breadth* 20)

(define (lazy-struct->pairs l)
  (define (rec items depth breadth)
    (cond ((not (lazy-pair? items)) items)
          ((or (< depth 0) (= breadth 0))
           (underlying-cons '<...> '()))
          (else
            (underlying-cons (rec (car items) (- depth 1) *max-breadth*)
                             (rec (cdr items) depth (- breadth 1))))))
  (rec l *max-depth* *max-breadth*))
