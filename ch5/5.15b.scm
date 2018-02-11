((eq? message 'print-and-reset-count)
 (display instruction-count)
 (newline)
 (set! instruction-count 0))
