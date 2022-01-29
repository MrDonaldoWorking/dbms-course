update Students
    set Marks = (
        select Count(Mark)
            from Marks
            where StudentId = :StudentId
    )
    where StudentId = :StudentId
