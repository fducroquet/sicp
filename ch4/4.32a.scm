(define (interleave l1 l2)
  (if (null? l1)
    l2
    (cons (car l1)
          (interleave l2 (cdr l1)))))

(define (pairs s t)
  (interleave
    (map (lambda (x) (list (car s) x))
         t)
    (pairs (cdr s) (cdr t))))

(define int-pairs (pairs integers integers))
