(define (extend-compile-environment frame env)
  (cons frame env))

(define (compile-lambda-body exp proc-entry compile-time-env)
  (let ((formals (lambda-parameters exp)))
    (append-instruction-sequences
      (make-instruction-sequence
        '(env proc argl)
        '(env)
        `(,proc-entry
           (assign env (op compiled-procedure-env) (reg proc))
           (assign env (op extend-environment) (const ,formals) (reg argl) (reg env))))
      (compile-sequence (lambda-body exp)
                        'val
                        'return
                        (extend-compile-environment formals compile-time-env)))))
