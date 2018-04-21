;; Construct the compiled factorial procedure and skip over the code for the body.
  (assign val (op make-compiled-procedure) (label entry1) (reg env))
  (goto (label after-lambda2))

;; Entry point of factorial.
entry1
  (assign env (op compiled-procedure-env) (reg proc))
  (assign env (op extend-environment) (const (n)) (reg argl) (reg env))
;; Construct the compiled iter procedure and skip over the code for the body.
  (assign val (op make-compiled-procedure) (label entry3) (reg env))
  (goto (label after-lambda4))

;; Entry point of iter.
entry3
  (assign env (op compiled-procedure-env) (reg proc))
  (assign env (op extend-environment) (const (product counter)) (reg argl) (reg env))
  (save continue)
  (save env)

;; Evaluation of (> counter n).
  (assign proc (op lookup-variable-value) (const >) (reg env))
  (assign val (op lookup-variable-value) (const n) (reg env))
  (assign argl (op list) (reg val))
  (assign val (op lookup-variable-value) (const counter) (reg env))
  (assign argl (op cons) (reg val) (reg argl))
  (test (op primitive-procedure?) (reg proc))
  (branch (label primitive-branch8))
compiled-branch9
  (assign continue (label after-call10))
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch8
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))

;; val contains the result of (> counter n).
after-call10
  (restore env)
  (restore continue)
  (test (op false?) (reg val))
  (branch (label false-branch6))
true-branch5 ; Return product.
  (assign val (op lookup-variable-value) (const product) (reg env))
  (goto (reg continue))

;; Compute (iter (* counter counter) (+ counter 1)).
false-branch6
  (assign proc (op lookup-variable-value) (const iter) (reg env))
  (save continue)
  (save proc)
  (save env)
  ; Computation of (+ counter 1)
  (assign proc (op lookup-variable-value) (const +) (reg env))
  (assign val (const 1))
  (assign argl (op list) (reg val))
  (assign val (op lookup-variable-value) (const counter) (reg env))
  (assign argl (op cons) (reg val) (reg argl))
  (test (op primitive-procedure?) (reg proc))
  (branch (label primitive-branch14))
compiled-branch15
  (assign continue (label after-call16))
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch14
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))

;; val contains (+ counter 1).
after-call16
  (assign argl (op list) (reg val))
  (restore env)
  (save argl)
;; Computation of (* counter product)
  (assign proc (op lookup-variable-value) (const *) (reg env))
  (assign val (op lookup-variable-value) (const product) (reg env))
  (assign argl (op list) (reg val))
  (assign val (op lookup-variable-value) (const counter) (reg env))
  (assign argl (op cons) (reg val) (reg argl))
  (test (op primitive-procedure?) (reg proc))
  (branch (label primitive-branch11))
compiled-branch12
  (assign continue (label after-call13))
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch11
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))

;; val contains (* counter product)
after-call13
  (restore argl)
  (assign argl (op cons) (reg val) (reg argl))
  (restore proc)
  (restore continue)
;; Apply iter
  (test (op primitive-procedure?) (reg proc))
  (branch (label primitive-branch17))
compiled-branch18
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch17
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
  (goto (reg continue))
after-call19
after-if7
after-lambda4

;; Add the iter procedure to the environment.
  (perform (op define-variable!) (const iter) (reg val) (reg env))
  (assign val (const ok))

;; Call (iter 1 1).
  (assign proc (op lookup-variable-value) (const iter) (reg env))
  (assign val (const 1))
  (assign argl (op list) (reg val))
  (assign val (const 1))
  (assign argl (op cons) (reg val) (reg argl))
  (test (op primitive-procedure?) (reg proc))
  (branch (label primitive-branch20))
compiled-branch21
  (assign val (op compiled-procedure-entry) (reg proc))
  (goto (reg val))
primitive-branch20
  (assign val (op apply-primitive-procedure) (reg proc) (reg argl))
  (goto (reg continue))
after-call22

after-lambda2
;; Assign the procedure to the variable factorial.
  (perform (op define-variable!) (const factorial) (reg val) (reg env))
  (assign val (const ok))
