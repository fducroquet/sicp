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
