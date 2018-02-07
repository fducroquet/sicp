(define (make-new-machine)
  (let ((pc (make-register 'pc))
        (flag (make-register 'flag))
        (the-instruction-sequence '()))
    (let* ((register-table
             (list (list 'pc pc) (list 'flag flag)))
           (the-ops
             (list (list 'initialize-stack
                         (lambda ()
                           (for-each
                             (lambda (reg) (reg 'initialize-stack))
                             (map cadr register-table)))))))
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
              ((eq? message 'operations) the-ops)
              (else (error "Unknown request: MACHINE" message))))
      dispatch)))

(define (update-insts! insts labels machine)
  (let ((pc (get-register machine 'pc))
        (flag (get-register machine 'flag))
        (ops (machine 'operations)))
    (for-each
      (lambda (inst)
        (set-instruction-execution-proc!
          inst
          (make-execution-procedure (instruction-text inst)
                                    labels
                                    machine
                                    pc
                                    flag
                                    ops)))
      insts)))

(define (make-execution-procedure inst labels machine pc flag ops)
  (cond ((eq? (car inst) 'assign)
         (make-assign inst machine labels ops pc))
        ((eq? (car inst) 'test)
         (make-test inst machine labels ops flag pc))
        ((eq? (car inst) 'branch)
         (make-branch inst machine labels flag pc))
        ((eq? (car inst) 'goto)
         (make-goto inst machine labels pc))
        ((eq? (car inst) 'save)
         (make-save inst machine pc))
        ((eq? (car inst) 'restore)
         (make-restore inst machine pc))
        ((eq? (car inst) 'perform)
         (make-perform inst machine labels ops pc))
        (else
          (error "Unknown instruction type: ASSEMBLE" inst))))
