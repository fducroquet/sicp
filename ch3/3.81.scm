(define (rand requests random-init)
  (define randoms
    (cons-stream random-init
                 (stream-map
                   (lambda (request n)
                     (cond ((eq? 'generate request)
                            (rand-update n))
                           ((and (pair? request)
                                 (eq? 'reset (car request)))
                            (cdr request))
                           (else
                             (error "Unknown request -- RAND" m))))
                   requests
                   randoms)))
  randoms)

; For testing
(define requests
  (list->stream (list 'generate 'generate 'generate (cons 'reset 31) 'generate
                      'generate (cons 'reset 42) 'generate 'generate 'generate)))
