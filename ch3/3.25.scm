(define (is-table? x)
  (define (is-records? x)
    (or (null? x)
        (and (pair? x) (pair? (car x)) (is-records? (cdr x)))))
  (and (pair? x)
       (is-records? (cdr x))))

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup-subtable keys subtable)
      (cond ((not subtable) #f)
            ((null? keys) (cdr subtable))
            ((not (is-table? subtable)) #f)
            (else
              (lookup-subtable (cdr keys) (assoc (car keys) (cdr subtable))))))

    (define (lookup keys)
      (lookup-subtable keys local-table))

    (define (insert-one! key value subtable)
      (let ((record (assoc key (cdr subtable))))
        (if record
          (set-cdr! record value)
          (set-cdr! subtable
                    (cons (cons key value)
                          (cdr subtable))))))

    (define (insert-subtable! keys value subtable)
      (let ((subsubtable (assoc (car keys) (cdr subtable))))
        (cond ((or (not subsubtable)
                   (not (is-table? subsubtable)))
               (set! subsubtable (list (car keys)))
               (set-cdr! subtable (cons subsubtable (cdr subtable)))))
        (if (null? (cdr keys))
          (set-cdr! subsubtable value)
          (insert-subtable! (cdr keys) value subsubtable))))

    (define (insert! keys value)
      (insert-subtable! keys value local-table))

    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc) insert!)
            (else (error "Unknown operation -- TABLE" m))))
    dispatch))

; For testing
(define table (make-table))
(define get (table 'lookup-proc))
(define put (table 'insert-proc))
