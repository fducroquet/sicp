(define (make-register name)
  (let ((contents '*unassigned*)
        (sources '())
        (trace? #f))
    (define (add-source source)
      (set! sources
        (adjoin-set source sources smaller?)))
    (define (set-value! value)
      (if trace?
        (begin
          (display "Register: ")
          (display name)
          (display ", old value: ")
          (display contents)
          (display ", new value: ")
          (display value)
          (newline)))
      (set! contents value))
    (define (dispatch message)
      (cond ((eq? message 'get) contents)
            ((eq? message 'set) set-value!)
            ((eq? message 'sources) sources)
            ((eq? message 'add-source) add-source)
            ((eq? message 'trace-on) (set! trace? #t))
            ((eq? message 'trace-off) (set! trace? #f))
            (else
              (error "Unknown request: REGISTER" message))))
    dispatch))

(define (trace-on machine register-name)
  ((get-register machine register-name) 'trace-on))

(define (trace-off machine register-name)
  ((get-register machine register-name) 'trace-off))
