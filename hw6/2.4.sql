select StudentId, StudentName, GroupName
    from Students, Groups, Plan
    where Students.GroupId = Groups.GroupId
        and Plan.GroupId = Groups.GroupId
        and Plan.CourseId = :CourseId
except
select Students.StudentId, StudentName, GroupName
    from Students, Groups, Marks
    where Students.GroupId = Groups.GroupId
        and Students.StudentId = Marks.StudentId
        and CourseId = :CourseId
