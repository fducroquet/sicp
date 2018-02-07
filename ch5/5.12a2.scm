((eq? message 'instructions-list) instructions-list)
((eq? message 'install-instructions-list)
 (lambda (insts)
   (set! instructions-list insts)))
