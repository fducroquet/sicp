(define (arity n)
  (lambda (args)
    (or (= (length args) n)
        (string-append "Arity error, expected "
                       (number->string n)
                       " argument(s), got "
                       (number->string (length args))
                       "."))))

(define (pos-arity args)
  (or (> (length args) 0)
      "Arity error, the procedure must have at least one argument."))

; pos starting at 0, but at 1 in error message.
(define (arg-type pos test)
  (lambda (args)
    (let ((arg (list-ref args pos)))
      (or (test arg)
          (string-append "Wrong argument type, argument "
                         (number->string (+ pos 1))
                         ":"
                         (procedure-name test)
                         " expected.")))))

(define (args-type test)
  (lambda (args)
    (define (check-pos p)
      (if (>= p (length args))
        true
        (let ((result ((arg-type p test) args)))
          (if (eq? result true)
            (check-pos (+ p 1))
            result))))
    (check-pos 0)))
