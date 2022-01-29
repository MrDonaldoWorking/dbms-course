select Students.StudentId, count(distinct Marks.CourseId) as Total, count(Mark) as Passed, count(distinct Marks.CourseId) - count(Mark) as Failed
    from Students
        left join Plan
    on Plan.GroupId = Students.GroupId
    left join Marks
    on Marks.StudentId = Students.StudentId and Plan.CourseId = Marks.CourseId
    group by Students.StudentId
