select StudentId, StudentName, GroupName
    from Students, Groups
    where Students.GroupId = Groups.GroupId
except
select Students.StudentId, StudentName, GroupName
    from Students, Groups, Marks, Courses
    where Students.GroupId = Groups.GroupId
        and Students.StudentId = Marks.StudentId
        and Courses.CourseId = Marks.CourseId
        and CourseName = :CourseName
