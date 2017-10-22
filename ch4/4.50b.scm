(define (ramb? exp) (tagged-list? exp 'ramb))

(define (ramb-choices exp) (cdr exp))

; Removes the item with the given index from the given list.
; Does nothing if the given index is higher than the list’s length.
(define (remove-index items index)
  (cond ((null? items) '())
        ((= index 0) (cdr items))
        (else (cons (car items)
                    (remove-index (cdr items) (- index 1))))))

(define (analyze-ramb exp)
  (let ((cprocs (map analyze (ramb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
        (if (null? choices)
          (fail)
          (let ((choice (random-integer (length choices))))
            ((list-ref choices choice)
             env
             succeed
             (lambda ()
               (try-next (remove-index choices choice)))))))
      (try-next cprocs))))
