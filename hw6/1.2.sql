select StudentId, StudentName, Students.GroupId
    from Students, Groups
    where Students.GroupId = Groups.GroupId and Groups.GroupName = :GroupName