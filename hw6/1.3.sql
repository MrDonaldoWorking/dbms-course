select distinct Students.StudentId, StudentName, GroupId
    from Students, Marks
    where Students.StudentId = Marks.StudentId
        and Marks.CourseId = :CourseId
        and Marks.Mark = :Mark
