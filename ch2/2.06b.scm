(add-1 one)

(add-1 (lambda (f)
         (lambda (x)
           (f x))))

(lambda (f) (lambda (x)
              (f ((lambda (f)
                    (lambda (x)
                      (f x)))
                  x))))

(lambda (f)
  (lambda (x)
    (f (f x))))
