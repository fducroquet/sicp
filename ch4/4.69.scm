(rule (ends-in-grandson (grandson)))

(rule (ends-in-grandson (?u . ?rest))
      (ends-in-grandson ?rest))

(rule ((grandson) ?x ?y)
      (grandson ?x ?y))

(rule ((great . ?rel) ?x ?y)
      (and (ends-in-grandson ?rel)
           (son ?x ?z)
           (?rel ?z ?y)))
