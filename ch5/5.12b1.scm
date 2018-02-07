(define (make-goto inst machine labels pc)
  (let ((dest (goto-dest inst)))
    (cond ((label-exp? dest)
           (let ((insts (lookup-label labels (label-exp-label dest))))
             (lambda ()
               (set-contents! pc insts))))
          ((register-exp? dest)
           (let ((reg (get-register machine (register-exp-reg dest))))
             ((machine 'add-entry-point) (register-exp-reg dest))
             (lambda ()
               (set-contents! pc (get-contents reg)))))
          (else
            (error "Bad GOTO instruction ASSEMBLE" inst)))))

(define (make-save inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    ((machine 'add-saved-reg) (stack-inst-reg-name inst))
    (lambda ()
      (push stack (get-contents reg))
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let ((reg (get-register machine
                           (stack-inst-reg-name inst))))
    ((machine 'add-saved-reg) (stack-inst-reg-name inst))
    (lambda ()
      (set-contents! reg (pop stack))
      (advance-pc pc))))
