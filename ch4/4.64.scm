(run '(assert! (rule (outranked-by2 ?staff-person ?boss)
                     (or (supervisor ?staff-person ?boss)
                         (and (outranked-by2 ?middle-manager ?boss)
                              (supervisor ?staff-person ?middle-manager))))))
