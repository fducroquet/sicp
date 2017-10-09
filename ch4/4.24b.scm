(time (run-in-interpreter
        '(define (fact n)
           (if (= n 0)
             1
             (* n (fact (- n 1)))))
        '(for (i 1 1000)
              (fact 500))))

(time (run-in-interpreter
        '(define (f x)
           (* 2 x))
        '(for (x 1 1000)
              (f x))))
