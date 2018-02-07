(define (make-save inst machine stack pc)
  (let* ((reg-name (stack-inst-reg-name inst))
         (reg (get-register machine reg-name)))
    (lambda ()
      (push stack (make-stack-entry reg-name (get-contents reg)))
      (advance-pc pc))))

(define (make-restore inst machine stack pc)
  (let* ((reg-name (stack-inst-reg-name inst))
         (reg (get-register machine reg-name)))
    (lambda ()
      (let ((entry (pop stack)))
        (if (eq? (stack-entry-name entry) reg-name)
          (begin
            (set-contents! reg (pop stack))
            (advance-pc pc))
          (error "Last saved value does not come from register"
                 reg-name
                 'original 'register:
                 (stack-entry-name entry)))))))

(define (make-stack-entry name contents)
  (cons name contents))
(define (stack-entry-name entry)
  (car entry))
(define (stack-entry-contents entry)
  (cdr entry))
