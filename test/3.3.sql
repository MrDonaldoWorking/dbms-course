insert into Sessions
  (TeamId, ContestId, Start)
  select TeamId, ContestId, current_timestamp as Start
    from Sessions
    where TeamId in (
      select TeamId
      from Sessions
      where ContestId = :ContestId
    )
    group by SessionId
