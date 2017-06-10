(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) false)
        ((equal? given-key (key (entry set-of-records)))
         (entry set-of-records))
        ((< given-key (key (entry set-of-records)))
         (lookup given-key (left-tree set-of-records)))
        (else
          (lookup given-key (right-tree set-of-records)))))
