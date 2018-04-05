;; Code for the register machine simulator.
(load "simulator-test.scm")

;; Code from chapter 4 needed by the explicit-control evaluator, plus a few 
;; functions from footnotes in section 5.4.
(load "5.23-eceval-support.scm")
; The evaluator itself.
(include "5.23-eceval.scm")

(define the-global-environment (setup-environment))
