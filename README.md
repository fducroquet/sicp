SICP Solutions
==============

An umptieth repository of solutions to most exercises from Abelson and Sussman’s 
[*Structure and Interpretation of Computer 
Programs*](https://mitpress.mit.edu/sicp/).

Link to PDF file with explanations (and code): [sicp.pdf](sicp.pdf). Looking in 
this file is probably the most convenient way to see how I solved a particular 
exercise (especially for the more complex ones): the `.scm` files don’t contain 
explanations since I put them in the PDF, and sometimes an exercise is split 
into several parts because it was more convenient to explain the parts 
separately.

The files named `<exercise-number>pre.scm` contain code from the book that 
precedes the exercise with the given number, or sometimes code from the text of 
the exercise. In most cases, the files named 
`<exercise-number><optional-letter>.scm` only contain the code written or 
changed to solve the exercise, not all the code the solution depends on.

To run the code, it’s often necessary to load multiple files, which is done by 
files generally named `<something>-test.scm` (not because they contain tests but 
because I used them to easily load and try out the code in the REPL). If you are 
here you probably want to compare your solutions to mine, or maybe you are stuck 
and want a hint to be able to write your own solution, so I guess trying out my 
code is not your main concern :-).

I used [Gambit Scheme](http://gambitscheme.org) for most exercises, the most 
notable exception being section 2.2.4 about the picture language, for which 
I used [Racket](http://racket-lang.org) and the `graphics.ss` library. Some of 
the code is not compatible with other interpreters, notably the definition of 
the macros for the streams and the functions for generating random numbers, but 
the changes needed to use another interpreter should be limited.
