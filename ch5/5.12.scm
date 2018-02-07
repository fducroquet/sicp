(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (stack (make-stack))
        (the-instruction-sequence '())
        (instructions-list '())
        (entry-points '())
        (saved-regs '()))
    (let ((the-ops
            (list (list 'initialize-stack
                        (lambda () (stack 'initialize)))))
          (register-table
            (list (list 'pc pc) (list 'flag flag))))
      (define (allocate-register name)
        (if (assoc name register-table)
          (error "Multiply defined register: " name)
          (set! register-table
            (cons (list name (make-register name))
                  register-table)))
        'register-allocated)
      (define (lookup-register name)
        (let ((val (assoc name register-table)))
          (if val
            (cadr val)
            (error "Unknown register: " name))))
      (define (execute)
        (let ((insts (get-contents pc)))
          (if (null? insts)
            'done
            (begin
              ((instruction-execution-proc (car insts)))
              (execute)))))
      (define (add-entry-point reg-name)
        (set! entry-points
          (adjoin-set reg-name entry-points smaller?)))
      (define (add-saved-reg reg-name)
        (set! saved-regs
          (adjoin-set reg-name saved-regs smaller?)))
      (define (dispatch message)
        (cond ((eq? message 'start)
               (set-contents! pc the-instruction-sequence)
               (execute))
              ((eq? message 'install-instruction-sequence)
               (lambda (seq)
                 (set! the-instruction-sequence seq)))
              ((eq? message 'allocate-register)
               allocate-register)
              ((eq? message 'get-register)
               lookup-register)
              ((eq? message 'install-operations)
               (lambda (ops)
                 (set! the-ops (append ops the-ops))))
              ((eq? message 'stack) stack)
              ((eq? message 'operations) the-ops)
              ((eq? message 'instructions-list) instructions-list)
              ((eq? message 'install-instructions-list)
               (lambda (insts)
                 (set! instructions-list insts)))
              ((eq? message 'add-entry-point) add-entry-point)
              ((eq? message 'entry-points) entry-points)
              ((eq? message 'add-saved-reg) add-saved-reg)
              ((eq? message 'saved-regs) saved-regs)
              (else (error "Unknown request: MACHINE" message))))
      dispatch)))

