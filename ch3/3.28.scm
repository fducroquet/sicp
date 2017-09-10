(define (or-gate a1 a2 output)
  (define (or-action-procedure)
    (let ((new-value
            (logical-or (get-signal a1) (get-signal a2))))
      (after-delay or-gate-delay
                   (lambda ()
                     (set-signal! output new-value)))))
  (add-action! a1 or-action-procedure)
  (add-action! a2 or-action-procedure)
  'ok)

(define (valid-signal? s)
  (or (= s 0) (= s 1)))

(define (logical-or s1 s2)
  (cond ((or (not (valid-signal? s1))
             (not (valid-signal? s2)))
         (error "Invalid signal" (list s1 s2)))
        ((or (= 1 s1) (= 1 s2)) 1)
        (else 0)))
