(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
      (lambda (segment)
        ((draw-line viewport)
         ((frame-coord-map frame) (start-segment segment))
         ((frame-coord-map frame) (end-segment segment))
         0))
      segment-list)))
