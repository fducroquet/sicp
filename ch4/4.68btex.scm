(rule (reverse ?x (?a . ?rest))
      (and (reverse ?reverse-rest ?rest)
           (append-to-form ?reverse-rest (?a) ?x)))
