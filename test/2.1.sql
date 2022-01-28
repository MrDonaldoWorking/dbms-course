select distinct TeamId
  from Runs, Sessions
  where Letter = :Letter
    and Accepted = 0
    and ContestId = :ContestId
    and Runs.SessionId = Sessions.SessionId
