(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (magnitude z)
    (sqrt-generic (add (square-generic (real-part z)) (square-generic (imag-part z)))))
  (define (angle z)
    (atan-generic (imag-part z) (real-part z)))
  (define (make-from-real-imag x y) (cons x y))
  (define (make-from-mag-ang r a)
    (cons (mul r (cosine a)) (mul r (sine a))))
  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-polar-package)
  ;; internal procedures
  (define (real-part z)
    (mul (magnitude z) (cosine (angle z))))
  (define (imag-part z)
    (mul (magnitude z) (sine (angle z))))
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-real-imag x y)
    (cons (sqrt-generic (add (square-generic x) (square-generic y)))))
  (define (make-from-mag-ang r a) (cons r a))
  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

(define (install-complex-package)
  ;; Imported procedures from rectangular and polar packages.
  (define (make-from-real-imag x y)
    ((get 'make-from-real-imag 'rectangular) x y))
  (define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar) r a))

  ;; Internal procedures.
  (define (add-complex z1 z2)
    (make-from-real-imag (add (real-part z1) (real-part z2))
                         (add (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (sub (real-part z1) (real-part z2))
                         (sub (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (mul (magnitude z1) (magnitude z2))
                       (add (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (div (magnitude z1) (magnitude z2))
                       (sub (angle z1) (angle z2))))

  ;; Interface to the rest of the system.
  (define (tag z) (attach-tag 'complex z))
  (put 'add '(complex complex)
       (lambda (z1 z2) (tag (add-complex z1 z2))))
  (put 'sub '(complex complex)
       (lambda (z1 z2) (tag (sub-complex z1 z2))))
  (put 'mul '(complex complex)
       (lambda (z1 z2) (tag (mul-complex z1 z2))))
  (put 'div '(complex complex)
       (lambda (z1 z2) (tag (div-complex z1 z2))))
  (put 'make-from-real-imag 'complex
       (lambda (x y) (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'complex
       (lambda (r a) (tag (make-from-mag-ang r a))))
  'done)

;; Definition af the generic procedures.
(define (sqrt-generic x)
  (apply-generic 'sqrt x))

(define (square-generic x)
  (apply-generic 'square x))

(define (atan-generic y x)
  (apply-generic 'atan y x))

(define (cosine x)
  (apply-generic 'cos x))

(define (sine x)
  (apply-generic 'sin x))

(define (install-number-package-ext type)
  (define (tag x)
    (attach-tag type x))
  (put 'sqrt (list type)
       (lambda (x) (tag (sqrt x))))
  (put 'square (list type)
       (lambda (x) (tag (square x))))
  (put 'cos (list type)
       (lambda (x) (tag (cos x))))
  (put 'sin (list type)
       (lambda (x) (tag (sin x))))
  (put 'atan (list type type)
       (lambda (y x) (tag (atan y x))))
  'done)

(put 'sqrt '(rational)
     (lambda (r)
       (make-rational (sqrt (numer r))
                      (sqrt (denom r)))))

(put 'square '(rational)
     (lambda (r)
       (make-rational (square (numer r))
                      (square (denom r)))))

(put 'sin '(rational)
     (lambda (r)
       (make-real (sin (/ (numer r)
                          (denom r))))))

(put 'cos '(rational)
     (lambda (r)
       (make-real (cos (/ (numer r)
                          (denom r))))))

(put 'atan '(rational rational)
     (lambda (r1 r2)
       (make-real (atan (/ (numer r1) (denom r1))
                        (/ (numer r2) (denom r2))))))
