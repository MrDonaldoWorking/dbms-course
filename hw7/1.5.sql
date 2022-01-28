delete
    from Students
    where StudentId in (
        select StudentId
            from Students natural left join Marks
            group by StudentId
            having Count(StudentId) <= 3
    )
