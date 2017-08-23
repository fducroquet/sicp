(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
      (begin (set! balance
               (- balance amount))
             balance)
      "Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (incorrect-password amount)
    (error "Incorrect password"))
  (define (make-dispatch password)
    (lambda (given-pass m)
      (cond ((not (eq? given-pass password))
             incorrect-password)
            ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            ((eq? m 'join) make-dispatch)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m)))))
  (make-dispatch password))

(define (make-join account curr-pass new-pass)
  ((account curr-pass 'join) new-pass))
