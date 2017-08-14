(define (no-drop? op)
  (get 'no-drop? op))
(put 'no-drop? 'raise true)
(put 'no-drop? 'project true)
(put 'no-drop? 'equ? true)
(put 'no-drop? '=zero? true)

(define (apply-generic op . args)
  (define (apply-proc proc args-list)
    (if (no-drop? op)
      (apply proc args-list)
      (drop (apply proc args-list))))

  (let* ((type-tags (map type-tag args))
         (proc (get op type-tags)))
    (if proc
      (apply-proc proc (map contents args))
      (let* ((type (highest-type type-tags))
             (raised-args (map (lambda (a)
                                 (raise-to-type type a))
                               args))
             (newproc (get op (map type-tag raised-args))))
        (if newproc
          (apply-proc newproc (map contents raised-args))
          (error "No method for these types"
                 (list op type-tags)))))))
