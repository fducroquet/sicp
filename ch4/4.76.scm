(define (merge-frames frame1 frame2)
  (cond ((eq? frame2 'failed) 'failed)
        ((null? frame1) frame2)
        (else
          (let ((binding (car frame1)))
            (merge-frames (cdr frame1)
                          (extend-if-possible (binding-variable binding)
                                              (binding-value binding)
                                              frame2))))))

(define (merge-frame-streams stream1 stream2)
  (stream-flatmap
    (lambda (frame)
      (stream-filter (lambda (f) (not (eq? f 'failed)))
                     (stream-map (lambda (frame2)
                                   (merge-frames frame frame2))
                                 stream1)))
    stream2))

(define (conjoin conjuncts frame-stream)
  (if (empty-conjunction? conjuncts)
    frame-stream
    (merge-frame-streams
      (qeval (first-conjunct conjuncts)
             frame-stream)
      (conjoin (rest-conjuncts conjuncts) frame-stream))))

(put 'and 'qeval conjoin)
