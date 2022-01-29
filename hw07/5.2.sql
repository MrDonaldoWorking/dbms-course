create view AllMarks as
    select StudentId, Count(Mark) as Marks
    from Students
        natural left join (
            select StudentId, CourseId, Mark from Marks
            union all
            select StudentId, CourseId, Mark from NewMarks
        ) AllMarks
    group by StudentId
