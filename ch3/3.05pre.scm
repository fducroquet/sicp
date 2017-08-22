(define rand
  (let ((x random-init))
    (lambda () (set! x (rand-update x)) x)))

(define (estimate-pi trials)
  (sqrt (/ 6 (monte-carlo trials
                          cesaro-test))))

(define (cesaro-test)
  (= (gcd (rand) (rand)) 1))

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1)
                 (+ trials-passed 1)))
          (else
            (iter (- trials-remaining 1)
                  trials-passed))))
  (iter trials 0))
