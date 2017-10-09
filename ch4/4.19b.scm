((variable? exp) (force (lookup-variable-value exp env)))
