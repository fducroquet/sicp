; and and or
(load "4.04b.scm")
(load "4.04d.scm")
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
; letrec
(load "4.20.scm")

(load "4.01-metacircular-evaluator.scm")
(load "4.35pre-amb-evaluator.scm")
(load "4.50b.scm") ; ramb
(load "4.51.scm") ; permanent-set!
(load "4.52.scm") ; if-fail
(load "4.78a.scm") ; require-fail
(load "4.54pre.scm") ; require predicate and selector
(load "4.54.scm") ; analyze-require

(define the-global-environment (setup-environment))

(define (run-in-interpreter . exps)
  (ambeval (sequence->exp exps)
           the-global-environment
           (lambda (val next-alternative)
             (if (not (eq? val 'ok))
               (user-print val)))
           ;; ambeval failure
           (lambda ()
             (announce-output ";;; There are no more values of")
             (user-print input))))

(load "4.35pre.scm")
(load "4.35pre2.scm")
(load "4.35.scm")
(load "4.36.scm")

;; 4.3.2 Logic puzzles
(load "4.38pre.scm") ; multiple dwellings

(load "4.45pre.scm") ; Parsing natural language
