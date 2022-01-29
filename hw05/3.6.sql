select StudentId, StudentName, GroupId
    from (select CourseId
            from Plan natural join Lecturers
            where LecturerName = :LecturerName)
        ConsideringCourses
        natural join Marks
        natural join Students
    where Mark = :Mark
