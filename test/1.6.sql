select TeamName
  from (
    select distinct TeamId, TeamName
      from (
        select ContestId, TeamId, TeamName
          from Teams natural join Sessions
        except
        select ContestId, TeamId, TeamName
          from Teams natural join Sessions natural join Runs
      ) Ids
  ) FilteredIds
