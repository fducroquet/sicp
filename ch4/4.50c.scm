; For the generator.
(run-in-interpreter
  '(define (parse-verb-phrase)
     (define (maybe-extend verb-phrase)
       (ramb verb-phrase
             (maybe-extend (list 'verb-phrase
                                 verb-phrase
                                 (parse-prepositional-phrase)))))
     (maybe-extend (parse-word verbs)))

  '(define (parse-noun-phrase)
     (define (maybe-extend noun-phrase)
       (ramb noun-phrase
             (maybe-extend (list 'noun-phrase
                                 noun-phrase
                                 (parse-prepositional-phrase)))))
     (maybe-extend (parse-simple-noun-phrase))))

; With adjectives and adverbs.
(run-in-interpreter
  '(define (parse-adjectives)
     (define (maybe-extend adjectives-list)
       (ramb adjectives-list
             (maybe-extend (append adjectives-list (list (parse-word adjectives))))))
     (maybe-extend (list (parse-word adjectives))))

  '(define (parse-simple-noun-phrase)
     (ramb (list 'simple-noun-phrase
                 (parse-word articles)
                 (parse-word nouns))
           (list 'adjectival-noun-phrase
                 (parse-word articles)
                 (append (parse-adjectives)
                         (list (parse-word nouns))))))

  '(define (parse-verb-phrase)
     (define (maybe-extend verb-phrase)
       (ramb verb-phrase
             (maybe-extend (list 'verb-phrase
                                 verb-phrase
                                 (parse-prepositional-phrase)))))
     (maybe-extend (parse-simple-verb-phrase)))

  '(define (parse-simple-verb-phrase)
     (ramb (list 'simple-verb
                 (parse-word verbs))
           (list 'verb-with-adverb
                 (parse-word verbs)
                 (parse-word adverbs)))))
