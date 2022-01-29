update Marks
    set Mark = (
        select NewMarks.Mark
            from NewMarks
            where NewMarks.StudentId = Marks.StudentId
                and NewMarks.CourseId = Marks.CourseId
                and NewMarks.Mark is not null
                and Marks.Mark is not null
    )
    where exists (
        select StudentId, CourseId, Mark
            from NewMarks
            where Marks.StudentId = NewMarks.StudentId
                and Marks.CourseId = NewMarks.CourseId
    )
