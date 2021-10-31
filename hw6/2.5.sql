select StudentId, StudentName, GroupName
    from Students, Groups, Plan, Courses
    where Students.GroupId = Groups.GroupId
        and Plan.GroupId = Groups.GroupId
        and Courses.CourseId = Plan.CourseId
        and Courses.CourseName = :CourseName
except
select Students.StudentId, StudentName, GroupName
    from Students, Groups, Marks, Courses
    where Students.GroupId = Groups.GroupId
        and Students.StudentId = Marks.StudentId
        and Courses.CourseId = Marks.CourseId
        and CourseName = :CourseName
