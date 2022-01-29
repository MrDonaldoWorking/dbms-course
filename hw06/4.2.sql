select StudentName, CourseName
    from (
        select distinct Students.StudentId, Plan.CourseId
            from Students, Plan, Marks
            where Students.GroupId = Plan.GroupId
                and Students.StudentId = Marks.StudentId
                and Marks.CourseId = Plan.CourseId
                and Marks.Mark <= 2
    ) DebtedIds, Students, Courses
    where DebtedIds.StudentId = Students.StudentId
        and DebtedIds.CourseId = Courses.CourseId
