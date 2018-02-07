(define (add-entry-point reg-name)
  (set! entry-points
    (adjoin-set reg-name entry-points smaller?)))

(define (add-saved-reg reg-name)
  (set! saved-regs
    (adjoin-set reg-name saved-regs smaller?)))

((eq? message 'add-entry-point) add-entry-point)
((eq? message 'entry-points) entry-points)
((eq? message 'add-saved-reg) add-saved-reg)
((eq? message 'saved-regs) saved-regs)
