;; Code for the register machine simulator.
;; (Loads the same files as simulator-test.scm except the definitions of various 
;; machines and the code from exercise 5.9 which forbids labels in operation 
;; arguments because make-compiled-procedure needs a label argument.)
(load "5.07pre-simulator.scm")
(load "5.08.scm") ; Forbid using the same label name at several places.

; Store additional information in the machine model.
(load "5.12set.scm")
(load "5.12.scm")
(load "5.12a1.scm")
(load "5.12b1.scm")
(load "5.12c.scm")

(load "5.14pre.scm")
(load "5.14.scm")

; Print the label preceding an instruction.
(load "5.17a.scm")
(load "5.17b.scm")
(load "5.17c.scm")

; Enable registers to be traced.
(load "5.18.scm")

; Breakpoints.
(load "5.19a.scm")
(load "5.19b.scm")
(load "5.19d.scm")

;; Code used by the evaluator itself

; Error checking in primitive procedures application.
; check-primitive-arguments: applies the checks for a procedure on given 
; arguments.
(load "5.30b1.scm")
; Check procedures useful in lots of cases.
(load "5.30b2.scm")
; For cadr, cddr, etc.
(load "5.30b3.scm")
; Range checks for substring and list-ref.
(load "5.30b4.scm")
; association-list?, for assoc.
(load "5.30b5.scm")
; Division by zero.
(load "5.30b6.scm")
; Procedure name.
(load "5.30b7.scm")

;; Code from chapter 4 needed by the explicit-control evaluator, plus a few 
;; functions from footnotes in section 5.4.
(load "eceval-support.scm")

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

; Error checking in the evaluation process.
(load "5.30a.scm")
