(run '(assert! (rule (append-to-form () ?y ?y))))
(run '(assert! (rule (append-to-form (?u . ?v) ?y (?u . ?z))
                     (append-to-form ?v ?y ?z))))
