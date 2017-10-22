(run-in-interpreter
  '(define adjectives '(adjective black big lazy beautiful clever))

  '(define (parse-adjectives)
     (define (maybe-extend adjectives-list)
       (amb adjectives-list
            (maybe-extend (append adjectives-list (list (parse-word adjectives))))))
     (maybe-extend (list (parse-word adjectives))))

  '(define (parse-simple-noun-phrase)
     (amb (list 'simple-noun-phrase
                (parse-word articles)
                (parse-word nouns))
          (list 'adjectival-noun-phrase
                (parse-word articles)
                (append (parse-adjectives)
                        (list (parse-word nouns))))))

  '(define adverbs '(adverb fast well))

  '(define (parse-verb-phrase)
     (define (maybe-extend verb-phrase)
       (amb verb-phrase
            (maybe-extend (list 'verb-phrase
                                verb-phrase
                                (parse-prepositional-phrase)))))
     (maybe-extend (parse-simple-verb-phrase)))

  '(define (parse-simple-verb-phrase)
     (amb (list 'simple-verb
                (parse-word verbs))
          (list 'verb-with-adverb
                (parse-word verbs)
                (parse-word adverbs)))))
