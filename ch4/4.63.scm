(rule (grand-son ?grand-father ?grand-son)
      (and (son ?grand-father ?father)
           (son ?father ?grand-son)))

(rule (son ?father ?son)
      (and (wife ?father ?wife)
           (son ?wife ?son)))
