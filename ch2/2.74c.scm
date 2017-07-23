(define (find-employee-record employee files)
  (if (null? files)
    #f
    (or (get-record employee (car files))
        (find-employee-record employee (cdr files)))))
