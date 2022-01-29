update Students
    set Debts = (
        select Count(distinct CourseId)
            from Plan
                natural join Students s
                natural left join Marks
            where Students.StudentId = s.StudentId
                and Mark is null
    )
    where GroupId = (
        select GroupId
            from Groups
            where GroupName = :GroupName
    )
