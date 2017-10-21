(run-in-interpreter
  '(define (parse-verb-phrase)
     (amb (parse-word verbs)
          (list 'verb-phrase
                (parse-verb-phrase)
                (parse-prepositional-phrase))))

  '(define (parse-noun-phrase)
     (amb (parse-simple-noun-phrase)
          (list 'noun-phrase
                (parse-simple-noun-phrase)
                (parse-prepositional-phrase)))))
