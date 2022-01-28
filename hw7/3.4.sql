update Students
    set Marks = (
        select Count(distinct CourseId)
            from Marks
            where Students.StudentId = Marks.StudentId
                and Marks.Mark is not null
    )
