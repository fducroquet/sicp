(define (get-record employee file)
  ((apply-generic 'get-record file) employee))
