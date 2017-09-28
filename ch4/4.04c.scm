((or? exp) (eval (or->if exp) env))
((and? exp) (eval (and->if exp) env))
