select StudentName, CourseName
    from (
        select StudentId, CourseId
            from Students, Plan
            where Students.GroupId = Plan.GroupId
        except
        select StudentId, CourseId from Marks
    ) DebtedIds, Students, Courses
    where DebtedIds.StudentId = Students.StudentId
        and DebtedIds.CourseId = Courses.CourseId
