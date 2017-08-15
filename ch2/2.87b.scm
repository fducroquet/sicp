(put '=zero? '(polynomial)
     (lambda (p) (=zero-terms? (term-list p))))
