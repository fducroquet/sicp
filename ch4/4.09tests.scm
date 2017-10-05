;; While
; Should print nothing
(define x -2)
(while (>= x 0)
       (display x))

; Test with an empty body, should print nothing
(define x -2)
(while (>= x 0))

; Simple test
; Should print 0 1 2 3 4 5 (one per line)
(define x 0)
(while (<= x 5)
       (display x)
       (newline)
       (set! x (+ x 1)))

;; Until
; Should print nothing
(define x -2)
(until (<= x 0)
       (display x))

; Test with an empty body, should print nothing
(define x -2)
(until (<= x 0))

; Simple test
; Should print 0 1 2 3 4 (one per line)
(define x 0)
(until (= x 5)
       (display x)
       (newline)
       (set! x (+ x 1)))

;; For
; Should all display 1 2 3 4 5
(for (x 1 (<= x 5) (+ x 1))
     (display x) (newline))

(for (x 1 (<= x 5) 1)
     (display x) (newline))

(for (x 1 (<= x 5))
     (display x) (newline))

(for (x 1 5 (+ x 1))
     (display x) (newline))

(for (x 1 5 1)
     (display x) (newline))

(for (x 1 5)
     (display x) (newline))

; Should display 0 -1 -2 -3 -4 -5
(for (x 0 -5 -1)
     (display x) (newline))

; Should display 0 .2 .4 .6 .8 1
(for (x 0 1.1 .2)
     (display x) (newline))

; Should display 1 .8 .6 .4 .2
(for (x 1 .1 -.2)
     (display x) (newline))

; Should display 16 8 4 2 1
(for (x 16 .9 (/ x 2))
     (display x) (newline))

; Should display:
; 0, 1
; 0, 2
; 1, 2
; 1, 3
; 2, 3
; 2, 4
; 3, 4
; 3, 5
; 4, 5
; 4, 6
; 5, 6
; 5, 7
(for (x 0 5)
     (for (y (+ x 1) (+ x 2))
          (display x)
          (display ", ")
          (display y)
          (newline)))

; Should display:
; 0, 0
; 0, 1
; 0, 2
; 0, 3
; 0, 4
; 0, 5
; 1, 0
; 1, 2
; 1, 4
; 2, 0
; 2, 3
(for (x 0 2)
     (for (y 0 10 (+ x 1))
          (display x)
          (display ", ")
          (display y)
          (newline)))
