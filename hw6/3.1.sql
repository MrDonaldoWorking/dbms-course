select StudentId, CourseId
    from Students, Plan
    where Students.GroupId = Plan.GroupId
union
select StudentId, CourseId from Marks
