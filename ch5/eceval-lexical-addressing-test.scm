(load "eceval-common.scm")

; Must be loaded before the evaluator or some operations are undefined when the 
; evaluator is assembled.
(load "eceval-compiler.scm")

; Open coding of some primitives.
; With at most two arguments.
(load "5.38a.scm")
(load "5.38b.scm")
; Arbitrary numbers of arguments.
(load "5.38d.scm")

; Redefines some procedures to use a compile-time environment.
(load "eceval-compiler-lexical-addressing.scm")

; Lexical-address-lookup and lexical-address-set!
(load "5.39.scm")
; Version of compile-lambda-body with compile-time environment.
(load "5.40.scm")
; find-variable to find the lexical address of a variable.
(load "5.41.scm")
; Versions of compile-variable and compile-assignment using lexical addresses.
(load "5.42.scm")

; Operations available in eceval.
(include "eceval-ops.scm")

; Add operations specific to the compiler with lexical addressing.
(set! eceval-operations
  (append (list (ecop lexical-address-lookup)
                (ecop lexical-address-set!))
          eceval-operations))

; The evaluator itself.
(load "eceval.scm")

(define the-global-environment (setup-environment))
