(define (native-num-op? exp)
  (and (application? exp)
       (memq (operator exp) '(+ - * /))))

(define (native-comp-op? exp)
  (and (application? exp)
       (memq (operator exp) '(= < > <= >=))))

(define (compile-native-num-op exp target linkage)
  (compile-native-op (to-binary (operator exp) (operands exp))
                     target
                     linkage))

(define (to-binary op args)
  (if (<= (length args) 2)
    (cons op args)
    (to-binary op (cons (list op (car args) (cadr args))
                        (cddr args)))))

(define (compile-native-comp-op exp target linkage)
  (define (and-args op args)
    (if (<= (length args) 2)
      (list (cons op args))
      (cons (list op (car args) (cadr args))
            (and-args op (cdr args)))))
  (let ((op (operator exp))
        (args (operands exp)))
    (if (<= (length args) 2)
      (compile-native-op exp target linkage)
      (compile (make-and (and-args op args)) target linkage))))

(define (make-and tests)
  (cons 'and tests))
