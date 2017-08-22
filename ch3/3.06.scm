(define rand
  (let ((x random-init))
    (lambda (action)
      (cond ((eq? action 'reset)
             (lambda (new-value)
               (set! x new-value)))
            ((eq? action 'generate)
             (set! x (rand-update x))
             x)
            (else
              (error "Unknown request -- RAND" x))))))
