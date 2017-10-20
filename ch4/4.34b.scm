(define (lazy-pair? exp)
  (tagged-list? exp 'lazy-pair))
