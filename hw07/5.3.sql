create view Debts as
    select StudentId, Count(distinct CourseId) as Debts
        from Plan
            natural join Students
            natural left join Marks
        where Mark is null
        group by StudentId

create view StudentDebts as
    select StudentId, 0 as Debts
        from Students
        where StudentId not in (
            select StudentId from Debts
        )
    union
    select StudentId, Debts from Debts
