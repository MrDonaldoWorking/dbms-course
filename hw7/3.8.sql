update Students
    set Debts = (
        select Count(distinct CourseId)
        from Plan
            natural join Students s
            natural left join Marks
        where Students.StudentId = s.StudentId
            and Marks.Mark is null
    ), Marks = (
        select Count(Mark)
            from Marks
            where Students.StudentId = Marks.StudentId
    )
