; This relies on Gambit's external representation of procedures.
(define (procedure-name proc)
  (define (last-space s n)
    (if (char=? (string-ref s n) #\ )
      n
      (last-space s (- n 1))))
  (let* ((s (object->string proc))
         (l (string-length s)))
    (substring s (last-space s (- l 1)) (- l 2))))
