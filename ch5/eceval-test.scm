; Code used with and without lexical addressing.
(load "eceval-common.scm")

; Must be loaded before the evaluator or some operations are undefined when the 
; evaluator is assembled.
(load "eceval-compiler.scm")

; Evaluation of arguments in left-to-right order.
; (load "5.36.scm")

; Preserving that always generates save and restore operations.
; (load "5.37.scm")

; Open coding of some primitives.
; With at most two arguments.
(load "5.38a.scm")
(load "5.38b.scm")
; Arbitrary numbers of arguments.
(load "5.38d.scm")

; Call interpreted procedures from compiled code.
(load "5.47.scm")

; Operations available in eceval (in a separate file so that the operations for 
; lexical addressing can be added in the version of the compiler with lexical 
; addressing).
(include "eceval-ops.scm")

; The evaluator itself.
(load "eceval.scm")

; Exercise 5.25: Lazy explicit-control evaluator
; Representation of thunks for lazy evaluation.
(load "../ch4/4.27pre-lazy-evaluator.scm")
(define force-it memoized-force-it)
(include "5.25.scm")

(define the-global-environment (setup-environment))
