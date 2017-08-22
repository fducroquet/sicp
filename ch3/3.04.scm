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

  (define (incorrect-password _)
    "Incorrect password")

  (define (call-the-cops _)
    "Cops called!")

  (let ((incorrect-count 0))
    (define (dispatch pass m)
      (if (not (eq? pass password))
        (begin
          (set! incorrect-count (+ incorrect-count 1))
          (if (> incorrect-count 7)
            call-the-cops
            incorrect-password))
        (begin
          (set! incorrect-count 0)
          (cond
            ((eq? m 'withdraw) withdraw)
            ((eq? m 'deposit) deposit)
            (else (error "Unknown request -- MAKE-ACCOUNT"
                         m))))))
    dispatch))
