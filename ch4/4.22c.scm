(define (analyze-or exp)
  (lambda (env)
    (define (combine-procs procs)
      (if (null? procs)
        false
        (let ((first ((car procs) env)))
          (if (true? first)
            first
            (combine-procs (cdr procs))))))
    (combine-procs (map analyze (or-tests exp)))))

(define (analyze-and exp)
  (let ((exps (and-tests exp)))
    (if (null? exps)
      (lambda (env) true)
      (lambda (env)
        (define (combine-procs procs)
          (let ((first ((car procs) env)))
            (if (true? first)
              (if (null? (cdr procs))
                first
                (combine-procs (cdr procs)))
              false)))
        (combine-procs (map analyze exps))))))

(define (analyze-unbind exp)
  (lambda (env)
    (unbind-var (unbind-variable exp) env)))
