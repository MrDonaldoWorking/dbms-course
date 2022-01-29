create view StudentDebts as
    select StudentId, 0 as Debts from Students
    except
    select StudentId, 0 as Debts
        from Students
        where StudentId in (
            select StudentId
            from Plan
                natural join Students
                natural left join Marks
            where Mark is null
        )
    union
    select StudentId, Count(distinct CourseId) as Debts
        from Plan
            natural join Students
            natural left join Marks
        where Mark is null
        group by StudentId
