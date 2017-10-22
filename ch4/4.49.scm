(run-in-interpreter
  '(define (parse-word word-list)
     (let ((words (cdr word-list)))
       (list-ref words (random-integer (length words))))))
