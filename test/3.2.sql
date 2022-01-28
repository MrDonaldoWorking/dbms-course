delete
  from Runs
  where SessionId in (
    select SessionId
    from Contests natural join Sessions
    where ContestName = :ContestName
  )
