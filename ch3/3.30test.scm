; Queues
(load "3.21pre.scm")
(load "3.21.scm")

; Inverter, and-gate, half-adder, full-adder.
(load "3.28pre.scm")
; Or-gate
(load "3.28.scm")
; Ripple-carry adder
(load "3.30.scm")
; Wires and agenda
(load "3.31pre.scm")

; Ripple-carry adder test
(define a1 (make-wire))
(define a2 (make-wire))
(define a3 (make-wire))
(define a4 (make-wire))
(define b1 (make-wire))
(define b2 (make-wire))
(define b3 (make-wire))
(define b4 (make-wire))
(define s1 (make-wire))
(define s2 (make-wire))
(define s3 (make-wire))
(define s4 (make-wire))
(define c (make-wire))

(define sum (make-wire))
(define carry (make-wire))

(probe 's1 s1)
(probe 's2 s2)
(probe 's3 s3)
(probe 's4 s4)
(probe 'carry c)

(ripple-carry-adder (list a1 a2 a3 a4) (list b1 b2 b3 a4) (list s1 s2 s3 s4) c)
(set-signal! a1 1)
(set-signal! a2 0)
(set-signal! a3 1)
(set-signal! a4 0)
(set-signal! b1 0)
(set-signal! b2 1)
(set-signal! b3 0)
(set-signal! b4 1)
(propagate)
(set-signal! a4 1)
(propagate)
