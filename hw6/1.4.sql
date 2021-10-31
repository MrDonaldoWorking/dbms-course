select distinct Students.StudentId, StudentName, GroupId
    from Students, Marks, Courses
    where Students.StudentId = Marks.StudentId
        and Courses.CourseId = Marks.CourseId
        and Marks.Mark = :Mark
        and Courses.CourseName = :CourseName
