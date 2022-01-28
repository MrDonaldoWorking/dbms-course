select TeamName
  from (
    select distinct TeamId
      from Sessions
      where ContestId = :ContestId
  ) Ids natural join Teams
