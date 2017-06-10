(define (encode-symbol symbol tree)
  (cond ((leaf? tree)
         (if (eq? symbol (symbol-leaf tree))
           '()
           (error "Symbol not present in tree -- ENCODE-SYMBOL" symbol)))
        ((member symbol (symbols (left-branch tree)))
         (cons 0
               (encode-symbol symbol (left-branch tree))))
        (else
          (cons 1
                (encode-symbol symbol (right-branch tree))))))
