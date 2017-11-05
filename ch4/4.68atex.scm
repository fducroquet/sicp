(rule (reverse () ()))
(rule (reverse (?a . ?rest) ?x)
      (and (reverse ?rest ?reverse-rest)
           (append-to-form ?reverse-rest (?a) ?x)))
