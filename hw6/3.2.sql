select StudentName, CourseName
    from (
        select StudentId, CourseId
            from Students, Plan
            where Students.GroupId = Plan.GroupId
        union
        select StudentId, CourseId from Marks
    ) SAndCIds, Students, Courses
    where SAndCIds.StudentId = Students.StudentId
        and SAndCIds.CourseId = Courses.CourseId
