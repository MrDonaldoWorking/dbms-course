select distinct TeamId
  from Runs, Sessions
  where Runs.SessionId = Sessions.SessionId
    and Accepted = 0
    and ContestId = :ContestId
