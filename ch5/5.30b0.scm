(define (primitive-checks proc) (caddr proc))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc) (cddr proc)))
       primitive-procedures))
