(rule (grandson ?grand-father ?grandson)
      (and (son ?grand-father ?father)
           (son ?father ?grandson)))

(rule (son ?father ?son)
      (and (wife ?father ?wife)
           (son ?wife ?son)))
