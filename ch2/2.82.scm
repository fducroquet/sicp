(define (apply-generic op . args)
  ;; To avoid trying to coerce the arguments to a given type several times.
  (define (unique elts)
    (if (null? elts)
      '()
      (let ((rest (unique (cdr elts))))
        (if (memq (car elts) rest)
          rest
          (cons (car elts) rest)))))
  ;; Tries to coerce all elements of args to the given type. Returns false if 
  ;; it’s impossible.
  (define (coerce-to-type type args)
    (if (null? args)
      '()
      (let* ((a (car args))
             (t (type-tag a))
             (others-coerced (coerce-to-type type (cdr args))))
        (cond ((not others-coerced) false)
              ((eq? t type)
               (cons a others-coerced))
              (else
                (let ((t->type (get-coercion t type)))
                  (if t->type
                    (cons (t->type a) others-coerced)
                    false)))))))
  (define (try-coercion type-tags)
    (define (try-types types-to-try)
      (if (null? types-to-try)
        (error "No method for these types"
               (list op type-tags))
        (let* ((type (car types-to-try))
               (coerced-args (coerce-to-type type args)))
          (if coerced-args
            (let ((proc (get op (map type-tag coerced-args))))
              (if proc
                (apply proc (map contents coerced-args))
                (try-types (cdr types-to-try))))
            (try-types (cdr types-to-try))))))
    (try-types (unique type-tags)))
  (let* ((type-tags (map type-tag args))
         (proc (get op type-tags)))
    (if proc
      (apply proc (map contents args))
      (try-coercion type-tags))))
