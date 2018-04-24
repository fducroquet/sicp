(define (compile-variable exp target linkage compile-time-env)
  (let ((address (find-variable exp compile-time-env)))
    (let ((modifies (if (eq? address 'not-found)
                      (list target 'env)
                      (list target)))
          (insts
            (if (eq? address 'not-found)
              `((assign env (op get-global-environment))
                (assign ,target
                        (op lookup-variable-value)
                        (const ,exp)
                        (reg env)))
              `((assign ,target
                        (op lexical-address-lookup)
                        (const ,address)
                        (reg env))))))
      (end-with-linkage
        linkage
        (make-instruction-sequence
          '(env)
          modifies
          insts)))))

(define (compile-assignment exp target linkage compile-time-env)
  (let ((var (assignment-variable exp))
        (get-value-code (compile (assignment-value exp) 'val 'next compile-time-env)))
    (let ((address (find-variable var compile-time-env)))
      (let ((modifies (if (eq? address 'not-found)
                        (list target 'env)
                        (list target)))
            (insts (if (eq? address 'not-found)
                     `((assign env (op get-global-environment))
                       (perform (op set-variable-value!)
                                (const ,var)
                                (reg val)
                                (reg env))
                       (assign ,target (const ok)))
                     `((perform (op lexical-address-set!)
                                (const ,address)
                                (reg val)
                                (reg env))
                       (assign ,target (const ok))))))
        (end-with-linkage
          linkage
          (preserving '(env)
                      get-value-code
                      (make-instruction-sequence
                        '(env val)
                        modifies
                        insts)))))))
