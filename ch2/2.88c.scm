(put 'neg '(polynomial)
     (lambda (p) (tag (neg-poly p))))
(put 'sub '(polynomial polynomial)
     (lambda (p1 p2) (tag (add-poly p1 (neg-poly p2)))))
