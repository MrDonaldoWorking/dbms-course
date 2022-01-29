update Students
    set Marks = Marks + (
        select Count(Mark)
            from NewMarks
            where Students.StudentId = NewMarks.StudentId
    )
