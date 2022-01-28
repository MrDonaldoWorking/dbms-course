create view StudentMarks as
    select StudentId, Count(Mark) as Marks
    from Students
        natural left join Marks
    group by StudentId
