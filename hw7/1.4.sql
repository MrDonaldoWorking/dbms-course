delete
    from Students
    where StudentId in (
        select StudentId as Cnt
            from Marks
            group by StudentId
            having Count(StudentId) >= 3
    )
