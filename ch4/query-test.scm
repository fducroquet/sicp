(load "../ch1/utils.scm")
(load "../ch1/1.21pre.scm") ; for prime?
(include "../ch3/3.50pre.gambc.scm")
(include "../ch3/3.50pre.scm") ; general stream operations
(include "../ch3/3.50.scm") ; map with multiple streams
(include "../ch3/3.66pre.scm") ; stream-append, interleave
(load "../ch2/2.33pre.scm") ; for accumulate aka fold-right
(define fold-right accumulate) ; for the definition of list->stream
(include "../ch3/3.74sup.scm") ; for list->stream

; From section 4.1
(define (tagged-list? exp tag)
  (if (pair? exp)
    (eq? (car exp) tag)
    false))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(include "../ch2/associative-table.scm")

(include "4.55pre-query-evaluator.scm")

; Data and database initialization
(include "4.55pre-data.scm")

(define (run query)
  (let ((q (query-syntax-process query)))
    (if (assertion-to-be-added? q)
      (add-rule-or-assertion! (add-assertion-body q))
      (qeval q (singleton-stream '())))))

(load "4.57.scm") ; can-replace
(load "4.58.scm") ; big-shot
(load "4.61pre.scm") ; append-to-form
(load "4.61.scm") ; next-to

(include "4.67.scm") ; loop-detector
(load "4.64.scm") ; outranked-by with infinite loop
