update Students
    set Debts = (
        select Count(distinct CourseId)
        from Plan
            natural join Students
            natural left join Marks
        where Students.StudentId = :StudentId
            and Marks.Mark is null
    )
    where StudentId = :StudentId
