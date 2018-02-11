(define (assemble controller-text machine)
  (extract-labels controller-text
                  (lambda (insts labels insts-list)
                    (update-insts! insts labels machine)
                    ((machine 'install-instructions-list) insts-list)
                    ((machine 'set-labels!) labels)
                    insts)))
