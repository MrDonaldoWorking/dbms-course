select StudentId, StudentName, GroupId
    from (select CourseId from Plan where LecturerId = :LecturerId) ConsideringCourses
        natural join Marks
        natural join Students
    where Mark = :Mark
