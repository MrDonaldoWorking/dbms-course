select StudentId, StudentName, GroupName
    from Students, Groups
    where Students.GroupId = Groups.GroupId
except
select Students.StudentId, StudentName, GroupName
    from Students, Groups, Marks
    where Students.GroupId = Groups.GroupId
        and Students.StudentId = Marks.StudentId
        and CourseId = :CourseId
