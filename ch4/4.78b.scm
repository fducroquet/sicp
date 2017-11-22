(define (assert! assertion)
  (add-rule-or-assertion! (query-syntax-process assertion))
  (display "Assertion added to data base.")
  'ok)

(define (request query)
  (let ((q (query-syntax-process query)))
    (instantiate q
                 (qeval q '())
                 (lambda (v f)
                   (contract-question-mark v)))))
