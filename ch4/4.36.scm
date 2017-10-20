(run-in-interpreter
  '(define (a-pythagorean-triple)
     (let ((j (an-integer-starting-from 1)))
       (let ((i (an-integer-between 1 j)))
         (let ((k (sqrt (+ (* i i) (* j j)))))
           (require (integer? k))
           (list i j k))))))
