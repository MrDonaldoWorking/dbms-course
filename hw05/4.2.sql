select StudentId, StudentName, GroupId
    from Courses
        natural join Plan
        natural join Students
    where CourseName = :CourseName
except
select StudentId, StudentName, GroupId
    from Courses
        natural join Students
        natural join Marks
    where CourseName = :CourseName
