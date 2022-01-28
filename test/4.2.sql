select TeamId, count(Letter) as Opened
  from (
    select distinct TeamId, Letter, ContestId
      from Runs natural join Sessions
  ) as Ids
  group by TeamId
