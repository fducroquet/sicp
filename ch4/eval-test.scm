(load "4.01-metacircular-evaluator.scm")

;; Section 4.1.2
; And and or
(load "4.04b.scm")
; And and or as derived forms
; (load "4.04b.scm")
; Additional syntax for cond
(load "4.05.scm")
; let expressions
(load "4.06.scm")
; let* expressions
(load "4.07.scm")
; Named let
(load "4.08.scm")
; Iterative constructs
(load "4.09while.scm")
(load "4.09until.scm")
(load "4.09for.scm")
; Alternative syntax
; (load "4.10a.scm") ; and => &&, or => ||, cond => case
(load "4.10b.scm") ; not => !
; (load "4.10c.scm)" ; parentheses for function arguments

;; Section 4.1.3

; Abstractions for environment manipulation
(load "4.12a.scm")
; Unbind variables
(load "4.13a.scm")

; Alternative structure for environment frames
(load "4.11.scm")
; Abstractions for environment manipulation
(load "4.12b.scm")
; Unbind variables
(load "4.13b.scm")

;; Section 4.1.6
(load "4.16a.scm")
(load "4.16b.scm")
; (load "4.16c.scm")

; (load "4.17.scm")
; Lazy evaluation of definitions and assignments’ values.
; (load "4.19a.scm")

; letrec
(load "4.20.scm")

;; Section 4.1.7
; Support additional forms (let, or, and… and scanning out defines in the new 
; version of the interpreter.
(load "4.22c.scm")
(load "4.22d.scm")

(load "4.24a.scm")

;;; Section 4.2: Lazy Evaluation
;; Section 4.2.2
; unless
; (load "4.26a.scm")

(load "4.27pre-lazy-evaluator.scm")

; Lazy evaluation as an extension to Scheme.
(load "4.31.scm")

; Lazy quoted lists
(load "4.33b.scm")

(define the-global-environment (setup-environment))

(define (run-in-interpreter . exps)
  (actual-value (sequence->exp exps) the-global-environment))

;; Procedures defining the evaluator’s behavior on following invocations of 
;; driver-loop or run-in-interpreter.
; Values for default evaluator
(define eval default-eval)
(define apply default-apply)
(define lazy false)
(define eval-if default-eval-if)
(define force-it memoized-force-it)
(define driver-loop default-driver-loop)

(define (default-evaluator)
  (set! eval default-eval)
  (set! apply default-apply)
  (set! lazy false)
  (set! eval-if default-eval-if)
  (set! driver-loop default-driver-loop))

(define (analyzing-evaluator)
  (set! eval analyzing-eval)
  (set! apply default-apply)
  (set! lazy false)
  (set! eval-if default-eval-if)
  (set! driver-loop default-driver-loop))

(define (lazy-evaluator)
  (set! eval default-eval)
  (set! apply lazy-apply)
  (set! lazy true)
  (set! eval-if lazy-eval-if)
  (set! force-it memoized-force-it)
  (set! driver-loop lazy-driver-loop))

(define (lazy-evaluator-unmemoized)
  (set! eval default-eval)
  (set! apply lazy-apply)
  (set! lazy true)
  (set! eval-if lazy-eval-if)
  (set! force-it unmemoized-force-it)
  (set! driver-loop lazy-driver-loop))

(define (extended-evaluator)
  (set! eval default-eval)
  (set! apply ext-apply)
  (set! lazy true)
  (set! eval-if lazy-eval-if)
  (set! force-it ext-force-it)
  (set! driver-loop default-driver-loop))
