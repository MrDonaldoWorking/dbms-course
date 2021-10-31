select distinct Students.StudentId
    from Lecturers, Students, Plan, Marks
    where Lecturers.LecturerName = :LecturerName
        and Lecturers.LecturerId = Plan.LecturerId
        and Students.StudentId = Marks.StudentId
        and Plan.GroupId = Students.GroupId
        and Marks.CourseId = Plan.CourseId
