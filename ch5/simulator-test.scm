(load "5.07pre-simulator.scm")
(load "5.08.scm") ; Forbid using the same label name at several places.
(load "5.09.scm") ; Forbid labels in operation arguments.

; Store additional information in the machine model. 
(load "5.12set.scm")
(load "5.12.scm")
(load "5.12a1.scm")
(load "5.12b1.scm")
(load "5.12c.scm")

(load "5.14pre.scm")
(load "5.14.scm")

; Print the label preceding an instruction.
(load "5.17a.scm")
(load "5.17b.scm")
(load "5.17c.scm")

; Enable registers to be traced.
(load "5.18.scm")

; Breakpoints.
(load "5.19a.scm")
(load "5.19b.scm")
(load "5.19d.scm")

(load "5.01pre.scm") ; Gcd-machine (iterative).
(load "5.02.scm") ; Fact-machine (iterative).
; gcd-machine2: reads inputs and prints results.
; gcd-machine3: does not use remainder as a primitive operation.
(load "5.03pre.scm")
(load "5.03asup.scm") ; Definitions used in 5.03a.
(load "5.03a.scm") ; Square roots usign Newton’s method, complex primitives.
(load "5.03b.scm") ; Square roots usign Newton’s method, expanded operations.
(load "5.04pre.scm") ; Recursive fact-machine, Fibonacci-machine.
(load "5.04a.scm") ; Recursive exponentiation.
(load "5.04b.scm") ; Iterative exponentiation.
(load "5.11a.scm") ; Fibonacci-machine with one fewer instruction.

(load "5.21a.scm") ; Count-leaves with double-recursion.
(load "5.21b.scm") ; Count-leaves with explicit counter.

(load "5.22a.scm") ; append
(load "5.22b.scm") ; append!
