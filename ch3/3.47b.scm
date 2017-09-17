(define (make-semaphore n)
  (let ((cell (list n)))
    (define (the-semaphore m)
      (cond ((eq? m 'acquire)
             (if (test-and-set! cell n -1)
               (the-semaphore 'acquire)))
            ((eq? m 'release)
             (test-and-set! cell n 1))))
    the-semaphore))

(define (test-and-set! cell max inc)
  (without-interrupts
    (lambda ()
      (let ((new-value (+ (car cell) inc)))
        (if (or (< new-value 0)
                (> new-value max))
          true
          (begin (set-car! cell (+ (car cell) inc))
                 false))))))
