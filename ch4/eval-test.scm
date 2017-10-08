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
(load "4.10a.scm")
; (load "4.10b.scm")

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
(load "4.16c.scm")

; (load "4.17.scm")

(define the-global-environment (setup-environment))
