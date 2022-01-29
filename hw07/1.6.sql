delete
    from Students
    where StudentId in (
        select StudentId
        from Plan
            natural join Students
            natural left join Marks
        where Mark is null
    )
