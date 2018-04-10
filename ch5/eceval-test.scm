;; Code for the register machine simulator.
(load "simulator-test.scm")

;; Code from chapter 4 needed by the explicit-control evaluator, plus a few 
;; functions from footnotes in section 5.4.
(load "5.23-eceval-support.scm")

; Additional syntax procedures and syntax transformers from chapter 4 for 
; exercise 5.23.
; and and or
(load "../ch4/4.04b.scm")
(load "../ch4/4.04d.scm")
; Predicate and selectors for cond clauses with =>
(load "../ch4/4.05.scm")
; let
(load "../ch4/4.06.scm")
; let*
(load "../ch4/4.07.scm")
; Named let
(load "../ch4/4.08.scm")
; While, until and for
(load "../ch4/4.09for.scm")
(load "../ch4/4.09until.scm")
(load "../ch4/4.09while.scm")
; letrec
(load "../ch4/4.20.scm")

; Additional selectors for cond clauses.
(load "5.24a.scm")

; The evaluator itself.
(include "5.23-eceval.scm")

; Exercise 5.25: Lazy explicit-control evaluator
; Representation of thunks for lazy evaluation.
(load "../ch4/4.27pre-lazy-evaluator.scm")
(define force-it memoized-force-it)
(include "5.25.scm")

(define the-global-environment (setup-environment))
