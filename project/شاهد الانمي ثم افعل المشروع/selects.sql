-- get person by name
select GetPersonByName(:PersonName);

-- Get all trainees
select distinct PersonId, PersonName 
    from PersonalTrainers
        left join People P ON P.PersonId = PersonalTrainers.PersonId 
    where trainerId = :TrainerId;

-- Get all teams by trainer
select distinct TeamId, TeamName 
    from TeamTrainers 
         left join Teams T ON T.TeamId = TeamTrainers.TeamId
    where TrainerId = :TrainerId;
