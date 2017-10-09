(define (run-in-interpreter . exps)
  (eval (sequence->exp exps) the-global-environment))
