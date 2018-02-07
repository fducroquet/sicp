(define (assemble controller-text machine)
  (extract-labels controller-text
                  (lambda (insts labels insts-list)
                    (update-insts! insts labels machine)
                    ((machine 'install-instructions-list) insts-list)
                    insts)))

(define (extract-labels text receive)
  (if (null? text)
    (receive '() '() '())
    (extract-labels
      (cdr text)
      (lambda (insts labels insts-list)
        (let ((next-inst (car text)))
          (if (symbol? next-inst)
            (receive insts
                     (cons (make-label-entry next-inst
                                             insts)
                           labels)
                     insts-list)
            (receive (cons (make-instruction next-inst)
                           insts)
                     labels
                     (adjoin-set next-inst insts-list smaller?))))))))
