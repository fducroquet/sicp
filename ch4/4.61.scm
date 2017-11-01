(run '(assert! (rule (?x next-to ?y in (?x ?y . ?u)))))
(run '(assert! (rule (?x next-to ?y in (?v . ?z))
                     (?x next-to ?y in ?z))))
