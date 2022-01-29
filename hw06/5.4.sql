select StudentId from Students
except
select StudentId
    from (
        select GroupId, CourseId
            from Lecturers, Plan
            where Lecturers.LecturerName = :LecturerName
                and Plan.LecturerId = Lecturers.LecturerId
    ) NeededCourses, Students
    where NeededCourses.GroupId = Students.GroupId
        and not exists (
            select Mark
                from Marks
                where Marks.StudentId = Students.StudentId
                    and Marks.CourseId = NeededCourses.CourseId
        )
