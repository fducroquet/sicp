(rule (meeting-time ?person ?day-and-time)
      (or (meeting whole-company ?day-and-time)
          (and (job ?person (?division . ?rest-job))
               (meeting ?division ?day-and-time))))
