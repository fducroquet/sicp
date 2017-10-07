(define (delete-binding-from-frame var frame)
  (define (delete prev-bindings curr-bindings)
    (if (null? curr-bindings)
      false
      (if (eq? (caar curr-bindings) var)
        (begin
          (set-cdr! prev-bindings (cdr curr-bindings))
          true)
        (delete curr-bindings (cdr curr-bindings)))))
  (delete frame (frame-bindings frame)))
