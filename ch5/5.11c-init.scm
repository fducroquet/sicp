(the-ops
  (list (list 'initialize-stack
              (lambda ()
                (for-each
                  (lambda (reg) (reg 'initialize-stack))
                  (map cadr register-table))))))
