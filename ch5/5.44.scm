(define (really-native? op compile-time-env)
  (eq? 'not-found (find-variable op compile-time-env)))

(define (native-op-in? ops exp compile-time-env)
  (and (application? exp)
       (let ((op (operator exp)))
         (and (memq op ops)
              (really-native? op compile-time-env)))))

(define (native-op? exp compile-time-env)
  (native-op-in? '(= + - * /) exp compile-time-env))

(define (native-num-op? exp compile-time-env)
  (native-op-in? '(+ - * /) exp compile-time-env))

(define (native-comp-op? exp compile-time-env)
  (native-op-in? '(= < > <= >=) exp compile-time-env))
