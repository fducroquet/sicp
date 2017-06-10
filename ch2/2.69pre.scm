(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))
