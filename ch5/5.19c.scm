((eq? message 'set-labels!)
 (lambda (labels2)
   (set! labels labels2)))
((eq? message 'set-breakpoint) set-breakpoint)
((eq? message 'proceed) (proceed))
((eq? message 'cancel-breakpoint) cancel-breakpoint)
((eq? message 'cancel-all-breakpoints) (cancel-all-breakpoints))
