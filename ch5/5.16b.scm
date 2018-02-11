((eq? message 'trace-on)
 (set! trace #t))
((eq? message 'trace-off)
 (set! trace #f))
