update Marks
    set Mark = (
        select NewMarks.Mark
            from NewMarks
            where NewMarks.StudentId = Marks.StudentId
                and NewMarks.CourseId = Marks.CourseId
    )
    where exists (
        select StudentId, CourseId, Mark
            from NewMarks
            where Marks.StudentId = NewMarks.StudentId
                and Marks.CourseId = NewMarks.CourseId
                and Marks.Mark < NewMarks.Mark
    )
