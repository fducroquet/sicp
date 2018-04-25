; compile-lambda-body is in 5.40.scm, compile-variable and compile-assignment in 
; 5.42.scm.

;; 5.5.1 Structure of the Compiler
(define (compile exp target linkage compile-time-env)
  (cond ((self-evaluating? exp)
         (compile-self-evaluating exp target linkage))
        ((quoted? exp)
         (compile-quoted exp target linkage))
        ((variable? exp)
         (compile-variable exp target linkage compile-time-env))
        ((assignment? exp)
         (compile-assignment exp target linkage compile-time-env))
        ((definition? exp)
         (compile-definition exp target linkage compile-time-env))
        ((if? exp)
         (compile-if exp target linkage compile-time-env))
        ((lambda? exp)
         (compile-lambda exp target linkage compile-time-env))
        ((begin? exp)
         (compile-sequence (begin-actions exp) target linkage compile-time-env))
        ((cond? exp) (compile (cond->if exp) target linkage compile-time-env))
        ((and? exp) (compile (and->if exp) target linkage compile-time-env))
        ((or? exp) (compile (or->if exp) target linkage compile-time-env))
        ((let? exp) (compile (let->combination exp) target linkage compile-time-env))
        ((let*? exp) (compile (let*->nested-lets exp) target linkage compile-time-env))
        ((letrec? exp) (compile (letrec->let exp) target linkage compile-time-env))
        ((while? exp) (compile (while->if exp) target linkage compile-time-env))
        ((until? exp) (compile (until->while exp) target linkage compile-time-env))
        ((for? exp) (compile (for->let exp) target linkage compile-time-env))
        ; Exercise 5.38.
        ; ((native-op? exp compile-time-env) (compile-native-op exp target linkage compile-time-env))
        ((native-num-op? exp compile-time-env) (compile-native-num-op exp target linkage compile-time-env))
        ((native-comp-op? exp compile-time-env) (compile-native-comp-op exp target linkage compile-time-env))
        ((application? exp)
         (compile-application exp target linkage compile-time-env))
        (else
          (error "Unknown expression type -- COMPILE" exp))))

;; 5.5.2 Compiling Expressions
(define (compile-definition exp target linkage compile-time-env)
  (let ((var (definition-variable exp))
        (get-value-code (compile (definition-value exp) 'val 'next compile-time-env)))
    (end-with-linkage
      linkage
      (preserving '(env)
                  get-value-code
                  (make-instruction-sequence
                    '(env val)
                    (list target)
                    `((perform (op define-variable!)
                               (const ,var)
                               (reg val)
                               (reg env))
                      (assign ,target (const ok))))))))

(define (compile-if exp target linkage compile-time-env)
  (let ((t-branch (make-label 'true-branch))
        (f-branch (make-label 'false-branch))
        (after-if (make-label 'after-if)))
    (let ((consequent-linkage
            (if (eq? linkage 'next) after-if linkage)))
      (let ((p-code (compile (if-predicate exp) 'val 'next compile-time-env))
            (c-code (compile (if-consequent exp) target consequent-linkage compile-time-env))
            (a-code (compile (if-alternative exp) target linkage compile-time-env)))
        (preserving '(env continue)
                    p-code
                    (append-instruction-sequences
                      (make-instruction-sequence '(val) '()
                                                 `((test (op false?) (reg val))
                                                   (branch (label ,f-branch))))
                      (parallel-instruction-sequences
                        (append-instruction-sequences t-branch c-code)
                        (append-instruction-sequences f-branch a-code))
                      after-if))))))

; Compiling sequences
(define (compile-sequence seq target linkage compile-time-env)
  (if (last-exp? seq)
    (compile (first-exp seq) target linkage compile-time-env)
    (preserving '(env continue)
                (compile (first-exp seq) target 'next compile-time-env)
                (compile-sequence (rest-exps seq) target linkage compile-time-env))))

(define (compile-lambda exp target linkage compile-time-env)
  (let ((proc-entry (make-label 'entry))
        (after-lambda (make-label 'after-lambda)))
    (let ((lambda-linkage
            (if (eq? linkage 'next) after-lambda linkage)))
      (append-instruction-sequences
        (tack-on-instruction-sequence
          (end-with-linkage
            lambda-linkage
            (make-instruction-sequence
              '(env)
              (list target)
              `((assign ,target (op make-compiled-procedure) (label ,proc-entry) (reg env)))))
          (compile-lambda-body exp proc-entry compile-time-env))
        after-lambda))))

;; 5.5.3 Compiling Combinations
(define (compile-application exp target linkage compile-time-env)
  (let ((proc-code (compile (operator exp) 'proc 'next compile-time-env))
        (operand-codes
          (map (lambda (operand) (compile operand 'val 'next compile-time-env))
               (operands exp))))
    (preserving '(env continue)
                proc-code
                (preserving '(proc continue)
                            (construct-arglist operand-codes)
                            (compile-procedure-call target linkage)))))

(define (spread-arguments operands compile-time-env)
  (if (null? operands)
    (empty-instruction-sequence)
    (if (= (length operands) 1)
      (compile (car operands) 'arg1 'next)
      (let ((first-operand-code (compile (car operands) 'arg1 'next compile-time-env))
            (second-operand-code (compile (cadr operands) 'arg2 'next compile-time-env)))
        (preserving
          '(env)
          first-operand-code
          (preserving '(arg1)
                      second-operand-code
                      (make-instruction-sequence '(arg1) '() '())))))))

;; 5.5.7 Interfacing Compiled Code to the Evaluator
(define the-empty-compile-environment '())

(define (compile-and-go expression)
  (let ((instructions
          (assemble
            (statements
              (compile expression 'val 'return the-empty-compile-environment))
            eceval)))
    (set! the-global-environment (setup-environment))
    (set-register-contents! eceval 'val instructions)
    (set-register-contents! eceval 'flag true)
    (start eceval)))

; Adaptation of procedures from exercise 5.38.
(define (compile-native-op exp target linkage compile-time-env)
  (let ((op (operator exp))
        (operands (operands exp)))
    (if (and (null? operands)
             (memq op '(- /)))
      (error "Operation takes at least one argument -- COMPILE" op)
      (let ((arg-regs
              (cond ((null? operands) '())
                    ((= (length operands) 1) '((reg arg1)))
                    (else '((reg arg1) (reg arg2)))))
            (operands-code (spread-arguments operands compile-time-env)))
        (end-with-linkage
          linkage
          (append-instruction-sequences
            operands-code
            (make-instruction-sequence
              '(arg1 arg2)
              (list target)
              (list (append `(assign ,target (op ,op))
                            arg-regs)))))))))

(define (compile-native-num-op exp target linkage compile-time-env)
  (compile-native-op (to-binary (operator exp) (operands exp))
                     target
                     linkage
                     compile-time-env))

(define (compile-native-comp-op exp target linkage compile-time-env)
  (define (and-args op args)
    (if (<= (length args) 2)
      (cons op args)
      (list (list op (car args) (cadr args))
            (and-args op (cdr args)))))
  (let ((op (car exp))
        (args (operands exp)))
    (if (<= (length args) 2)
      (compile-native-op exp target linkage compile-time-env)
      (compile (make-and (and-args op args)) target linkage compile-time-env))))
