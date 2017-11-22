(run-in-interpreter
  ;; Operation table from chapter 2.
  '(define (assoc key records)
     (cond ((null? records) false)
           ((equal? key (caar records)) (car records))
           (else (assoc key (cdr records)))))

  '(define (make-table)
     (let ((local-table (list '*table*)))
       (define (lookup key-1 key-2)
         (let ((subtable (assoc key-1 (cdr local-table))))
           (if subtable
             (let ((record (assoc key-2 (cdr subtable))))
               (if record
                 (cdr record)
                 false))
             false)))
       (define (insert! key-1 key-2 value)
         (let ((subtable (assoc key-1 (cdr local-table))))
           (if subtable
             (let ((record (assoc key-2 (cdr subtable))))
               (if record
                 (set-cdr! record value)
                 (set-cdr! subtable
                           (cons (cons key-2 value)
                                 (cdr subtable)))))
             (set-cdr! local-table
                       (cons (list key-1
                                   (cons key-2 value))
                             (cdr local-table)))))
         'ok)
       (define (dispatch m)
         (cond ((eq? m 'lookup-proc) lookup)
               ((eq? m 'insert-proc!) insert!)
               (else (error "Unknown operation -- TABLE" m)))) 
       dispatch))

  '(define operation-table (make-table))
  '(define get (operation-table 'lookup-proc))
  '(define put (operation-table 'insert-proc!))

  '(define (prompt-for-input string)
     (newline) (newline) (display string) (newline))

  ;; 4.4.4.1 The Driver Loop and Instantiation
  '(define input-prompt ";;; Query-input:")
  '(define output-prompt ";;; Query-results:")

  '(define (assert! assertion)
     (add-rule-or-assertion! (query-syntax-process assertion))
     (display "Assertion added to data base.")
     'ok)

  '(define (request query)
     (let ((q (query-syntax-process query)))
       (instantiate q
                    (qeval q '())
                    (lambda (v f)
                      (contract-question-mark v)))))

  '(define (instantiate exp frame unbound-var-handler)
     (define (copy exp)
       (cond ((var? exp)
              (let ((binding (binding-in-frame exp frame)))
                (if binding
                  (copy (binding-value binding))
                  (unbound-var-handler exp frame))))
             ((pair? exp)
              (cons (copy (car exp)) (copy (cdr exp))))
             (else exp)))
     (copy exp))

  ;; 4.4.4.2 The Evaluator
  '(define (qeval query frame)
     (let ((qproc (get (type query) 'qeval)))
       (if qproc
         (qproc (contents query) frame)
         (simple-query query frame))))

  '(define (simple-query query-pattern frame)
     (amb (find-assertions query-pattern frame)
          (apply-rules query-pattern frame)))

  '(define (conjoin conjuncts frame)
     (if (empty-conjunction? conjuncts)
       frame
       (conjoin (rest-conjuncts conjuncts)
                (qeval (first-conjunct conjuncts)
                       frame))))

  '(put 'and 'qeval conjoin)

  '(define (disjoin disjuncts frame)
     (require (not (empty-disjunction? disjuncts)))
     (ramb (qeval (first-disjunct disjuncts) frame)
           (disjoin (rest-disjuncts disjuncts) frame)))

  '(put 'or 'qeval disjoin)

  '(define (negate operands frame)
     (require-fail (qeval (negated-query operands) frame))
     frame)

  '(put 'not 'qeval negate)

  '(define (lisp-value call frame)
     (require (execute
                (instantiate
                  call
                  frame
                  (lambda (v f)
                    (error "Unknown pat var -- LISP-VALUE" v)))))
     frame)

  '(put 'lisp-value 'qeval lisp-value)

  '(define (execute exp)
     (apply (eval (predicate exp))
            (args exp)))

  '(define (always-true ignore frame) frame)

  '(put 'always-true 'qeval always-true)

  ;; 4.4.4.3 Finding Assertions by Pattern Matching
  '(define (find-assertions pattern frame)
     (pattern-match pattern (an-element-of (fetch-assertions pattern)) frame))

  '(define (pattern-match pat dat frame)
     (cond ((equal? pat dat) frame)
           ((var? pat) (extend-if-consistent pat dat frame))
           ((and (pair? pat) (pair? dat))
            (pattern-match (cdr pat)
                           (cdr dat)
                           (pattern-match (car pat)
                                          (car dat)
                                          frame)))
           (else (amb))))

  '(define (extend-if-consistent var dat frame)
     (let ((binding (binding-in-frame var frame)))
       (if binding
         (pattern-match (binding-value binding) dat frame)
         (extend var dat frame))))

  ;; 4.4.4.4 Rules and Unification
  '(define (apply-rules pattern frame)
     (apply-a-rule (an-element-of (fetch-rules pattern)) pattern frame))

  '(define (apply-a-rule rule query-pattern query-frame)
     (let ((clean-rule (rename-variables-in rule)))
       (qeval (rule-body clean-rule)
              (unify-match query-pattern
                           (conclusion clean-rule)
                           query-frame))))

  '(define (rename-variables-in rule)
     (let ((rule-application-id (new-rule-application-id)))
       (define (tree-walk exp)
         (cond ((var? exp)
                (make-new-variable exp rule-application-id))
               ((pair? exp)
                (cons (tree-walk (car exp))
                      (tree-walk (cdr exp))))
               (else exp)))
       (tree-walk rule)))

  '(define (unify-match p1 p2 frame)
     (cond ((equal? p1 p2) frame)
           ((var? p1) (extend-if-possible p1 p2 frame))
           ((var? p2) (extend-if-possible p2 p1 frame))
           ((and (pair? p1) (pair? p2))
            (unify-match (cdr p1)
                         (cdr p2)
                         (unify-match (car p1)
                                      (car p2)
                                      frame)))
           (else (amb))))

  '(define (extend-if-possible var val frame)
     (let ((binding (binding-in-frame var frame)))
       (cond (binding
               (unify-match (binding-value binding) val frame))
             ((var? val)
              (let ((binding (binding-in-frame val frame)))
                (if binding
                  (unify-match var (binding-value binding) frame)
                  (extend var val frame))))
             (else
               (require (not (depends-on? val var frame)))
               (extend var val frame)))))

  '(define (depends-on? exp var frame)
     (define (tree-walk e)
       (cond ((var? e)
              (if (equal? var e)
                true
                (let ((b (binding-in-frame e frame)))
                  (if b
                    (tree-walk (binding-value b))
                    false))))
             ((pair? e)
              (or (tree-walk (car e))
                  (tree-walk (cdr e))))
             (else false)))
     (tree-walk exp))

  ;; 4.4.4.5 Maintaining the Data Base
  '(define THE-ASSERTIONS '())

  '(define (fetch-assertions pattern)
     (if (use-index? pattern)
       (get-indexed-assertions pattern)
       (get-all-assertions)))

  '(define (get-all-assertions) THE-ASSERTIONS)

  '(define (get-indexed-assertions pattern)
     (get-list (index-key-of pattern) 'assertion-list))

  '(define (get-list key1 key2)
     (let ((s (get key1 key2)))
       (if s s '())))

  '(define THE-RULES '())

  '(define (fetch-rules pattern)
     (if (use-index? pattern)
       (get-indexed-rules pattern)
       (get-all-rules)))

  '(define (get-all-rules) THE-RULES)

  '(define (get-indexed-rules pattern)
     (append
       (get-list (index-key-of pattern) 'rule-list)
       (get-list '? 'rule-list)))

  '(define (add-rule-or-assertion! assertion)
     (if (rule? assertion)
       (add-rule! assertion)
       (add-assertion! assertion)))

  '(define (add-assertion! assertion)
     (store-assertion-in-index assertion)
     (set! THE-ASSERTIONS (cons assertion THE-ASSERTIONS))
     'ok)

  '(define (add-rule! rule)
     (store-rule-in-index rule)
     (set! THE-RULES (cons rule THE-RULES))
     'ok)

  '(define (store-assertion-in-index assertion)
     (if (indexable? assertion)
       (let ((key (index-key-of assertion)))
         (put key
              'assertion-list
              (cons assertion (get-list key 'assertion-list))))))

  '(define (store-rule-in-index rule)
     (let ((pattern (conclusion rule)))
       (if (indexable? pattern)
         (let ((key (index-key-of pattern)))
           (put key
                'rule-list
                (cons rule (get-list key 'rule-list)))))))

  '(define (indexable? pat)
     (or (constant-symbol? (car pat))
         (var? (car pat))))

  '(define (index-key-of pat)
     (let ((key (car pat)))
       (if (var? key) '? key)))

  '(define (use-index? pat)
     (constant-symbol? (car pat)))

  ;; 4.4.4.7 Query Syntax Procedures
  '(define (type exp)
     (if (pair? exp)
       (car exp)
       (error "Unknown expression TYPE" exp)))

  '(define (contents exp)
     (if (pair? exp)
       (cdr exp)
       (error "Unknown expression CONTENTS" exp)))

  '(define (empty-conjunction? exps) (null? exps))
  '(define (first-conjunct exps) (car exps))
  '(define (rest-conjuncts exps) (cdr exps))

  '(define (empty-disjunction? exps) (null? exps))
  '(define (first-disjunct exps) (car exps))
  '(define (rest-disjuncts exps) (cdr exps))

  '(define (negated-query exps) (car exps))

  '(define (predicate exps) (car exps))
  '(define (args exps) (cdr exps))

  '(define (rule? statement)
     (tagged-list? statement 'rule))

  '(define (tagged-list? exp tag)
     (if (pair? exp)
       (eq? (car exp) tag)
       false))

  '(define (conclusion rule) (cadr rule))

  '(define (rule-body rule)
     (if (null? (cddr rule))
       '(always-true)
       (caddr rule)))

  '(define (query-syntax-process exp)
     (map-over-symbols expand-question-mark exp))

  '(define (map-over-symbols proc exp)
     (cond ((pair? exp)
            (cons (map-over-symbols proc (car exp))
                  (map-over-symbols proc (cdr exp))))
           ((symbol? exp) (proc exp))
           (else exp)))

  '(define (expand-question-mark symbol)
     (let ((chars (symbol->string symbol)))
       (if (string=? (substring chars 0 1) "?")
         (list '?
               (string->symbol (substring chars 1 (string-length chars))))
         symbol)))

  '(define (var? exp)
     (tagged-list? exp '?))

  '(define (constant-symbol? exp) (symbol? exp))

  '(define rule-counter 0)

  '(define (new-rule-application-id)
     (set! rule-counter (+ 1 rule-counter))
     rule-counter)

  '(define (make-new-variable var rule-application-id)
     (cons '? (cons rule-application-id (cdr var))))

  '(define (contract-question-mark variable)
     (string->symbol
       (string-append "?"
                      (if (number? (cadr variable))
                        (string-append (symbol->string (caddr variable))
                                       "-"
                                       (number->string (cadr variable)))
                        (symbol->string (cadr variable))))))

  ;; 4.4.4.8 Frames and Bindings
  '(define (make-binding variable value)
     (cons variable value))

  '(define (binding-variable binding)
     (car binding))

  '(define (binding-value binding)
     (cdr binding))

  '(define (binding-in-frame variable frame)
     (assoc variable frame))

  '(define (extend variable value frame)
     (cons (make-binding variable value) frame))

  '(define microshaft-data-base
     '((address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))
       (job (Bitdiddle Ben) (computer wizard))
       (salary (Bitdiddle Ben) 60000)
       (supervisor (Bitdiddle Ben) (Warbucks Oliver))

       (address (Hacker Alyssa P) (Cambridge (Mass Ave) 78))
       (job (Hacker Alyssa P) (computer programmer))
       (salary (Hacker Alyssa P) 40000)
       (supervisor (Hacker Alyssa P) (Bitdiddle Ben))

       (address (Fect Cy D) (Cambridge (Ames Street) 3))
       (job (Fect Cy D) (computer programmer))
       (salary (Fect Cy D) 35000)
       (supervisor (Fect Cy D) (Bitdiddle Ben))

       (address (Tweakit Lem E) (Boston (Bay State Road) 22))
       (job (Tweakit Lem E) (computer technician))
       (salary (Tweakit Lem E) 25000)
       (supervisor (Tweakit Lem E) (Bitdiddle Ben))

       (address (Reasoner Louis) (Slumerville (Pine Tree Road) 80))
       (job (Reasoner Louis) (computer programmer trainee))
       (salary (Reasoner Louis) 30000)
       (supervisor (Reasoner Louis) (Hacker Alyssa P))

       (address (Warbucks Oliver) (Swellesley (Top Head Road)))
       (job (Warbucks Oliver) (administration big wheel))
       (salary (Warbucks Oliver) 150000)

       (address (Scrooge Eben) (Weston (Shady Lane) 10))
       (job (Scrooge Eben) (accounting chief accountant))
       (salary (Scrooge Eben) 75000)
       (supervisor (Scrooge Eben) (Warbucks Oliver))

       (address (Cratchet Robert) (Allston (N Harvard Street) 16))
       (job (Cratchet Robert) (accounting scrivener))
       (salary (Cratchet Robert) 18000)
       (supervisor (Cratchet Robert) (Scrooge Eben))

       (address (Aull DeWitt) (Slumerville (Onion Square) 5))
       (job (Aull DeWitt) (administration secretary))
       (salary (Aull DeWitt) 25000)
       (supervisor (Aull DeWitt) (Warbucks Oliver))

       (can-do-job (computer wizard) (computer programmer))
       (can-do-job (computer wizard) (computer technician))
       (can-do-job (computer programmer) (computer programmer trainee))
       (can-do-job (administration secretary) (administration big wheel))

       (rule (lives-near ?person-1 ?person-2)
             (and (address ?person-1 (?town . ?rest-1))
                  (address ?person-2 (?town . ?rest-2))
                  (not (same ?person-1 ?person-2))))

       (rule (same ?x ?x))

       (rule (wheel ?person)
             (and (supervisor ?middle-manager ?person)
                  (supervisor ?x ?middle-manager)))

       (rule (outranked-by ?staff-person ?boss)
             (or (supervisor ?staff-person ?boss)
                 (and (supervisor ?staff-person ?middle-manager)
                      (outranked-by ?middle-manager ?boss))))))

  ;; Database initialization, from the code available on the SICP’s website
  '(define (initialize-data-base rules-and-assertions)
     (define (deal-out r-and-a rules assertions)
       (cond ((null? r-and-a)
              (set! THE-ASSERTIONS assertions)
              (set! THE-RULES rules)
              'done)
             (else
               (let ((s (query-syntax-process (car r-and-a))))
                 (cond ((rule? s)
                        (store-rule-in-index s)
                        (deal-out (cdr r-and-a)
                                  (cons s rules)
                                  assertions))
                       (else
                         (store-assertion-in-index s)
                         (deal-out (cdr r-and-a)
                                   rules
                                   (cons s assertions))))))))
     (deal-out rules-and-assertions '() '()))

  '(initialize-data-base microshaft-data-base))
