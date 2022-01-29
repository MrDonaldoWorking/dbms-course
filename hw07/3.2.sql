update Students
    set Marks = (
        select Count(Mark)
            from Marks
            where Students.StudentId = Marks.StudentId
    )
