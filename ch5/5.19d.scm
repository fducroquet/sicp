(define (make-breakpoint label n) (cons label n))
(define (breakpoint-label breakpoint) (car breakpoint))
(define (breakpoint-offset breakpoint) (cdr breakpoint))

(define (make-instruction text) (list text '() '() '()))
(define (instruction-breakpoint inst) (cadddr inst))
(define (set-instruction-breakpoint! inst breakpoint)
  (set-car! (cdddr inst) breakpoint))

(define (breakpoint? inst)
  (not (null? (instruction-breakpoint inst))))

(define (cancel-breakpoint! inst)
  (set-instruction-breakpoint! inst '()))
