(define gcd-machine2
  (make-machine
    '(a b t)
    (list (list 'rem remainder) (list '= =)
          (list 'read read) (list 'print display))
    '(gcd-loop
       (assign a (op read))
       (assign b (op read))
     test-b
       (test (op =) (reg b) (const 0))
       (branch (label gcd-done))
       (assign t (op rem) (reg a) (reg b))
       (assign a (reg b))
       (assign b (reg t))
       (goto (label test-b))
     gcd-done
       (perform (op print) (reg a))
       (goto (label gcd-loop)))))

(define gcd-machine3
  (make-machine
    '(a b t)
    (list (list 'rem remainder) (list '= =) (list '- -) (list '< <))
    '(test-b
       (test (op =) (reg b) (const 0))
       (branch (label gcd-done))
       (assign t (reg a))
     rem-loop
       (test (op <) (reg t) (reg b))
       (branch (label rem-done))
       (assign t (op -) (reg t) (reg b))
       (goto (label rem-loop))
     rem-done
       (assign a (reg b))
       (assign b (reg t))
       (goto (label test-b))
     gcd-done)))
