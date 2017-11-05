(define (simple-query query-pattern frame-stream)
  (stream-flatmap
    (lambda (frame)
      (if (in-loop? query-pattern frame)
        the-empty-stream
        (begin
          (add-to-history! query-pattern frame)
          (stream-append-delayed
            (find-assertions query-pattern frame)
            (delay (apply-rules query-pattern frame))))))
    frame-stream))

(define (in-loop? query frame)
  (define (iter key history)
    (if (null? history)
      #f
      (let ((entry (car history)))
        (or (and (equal? key (entry-key entry))
                 (reachable-from? (entry-frame entry) frame))
            (iter key (cdr history))))))
  (iter (get-key query frame) *history*))

(define (reachable-from? target origin)
  (cond ((eq? origin target) #t)
        ((null? origin) #f)
        (else (reachable-from? target (cdr origin)))))

(define (get-key query frame)
  (instantiate query frame (lambda (var f)
                             (if (number? (cadr var))
                               (cons (car var) (cddr var))
                               var))))

(define *history* '())
(define (reset-history!)
  (set! *history* '()))

(define (make-history-entry query frame)
  (cons (get-key query frame) frame))

(define (entry-frame history-entry)
  (cdr history-entry))

(define (entry-key history-entry)
  (car history-entry))

(define (add-to-history! query frame)
  (set! *history* (cons (make-history-entry query frame) *history*)))
