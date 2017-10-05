(define (while? exp)
  (tagged-list? exp 'while))

(define (while-predicate exp)
  (cadr exp))

(define (while-body exp)
  (cddr exp))

(define (make-while test body)
  (list 'while test body))

(define (make-not exp)
  (list 'not exp))

(define (while->if exp)
  (let ((proc-name (gensym)))
    (sequence->exp
      (list
        (make-define
          (list proc-name)
          (make-if (while-predicate exp)
                   (sequence->exp
                     (append
                       (while-body exp)
                       (list (list proc-name))))
                   'false))
        (list proc-name)))))
