(define (integrate-series s)
  (stream-map / s integers))
