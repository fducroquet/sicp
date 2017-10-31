(run '(assert!
        (rule (big-shot ?person ?division)
              (and (job ?person (?division . ?rest-job))
                   (or (not (supervisor ?person ?boss))
                       (and (supervisor ?person ?boss)
                            (not (job ?boss (?division . ?rest-job-boss)))))))))
