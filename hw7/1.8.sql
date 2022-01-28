delete
    from Students
    where StudentId in (
        select StudentId from Students
        except
        select StudentId
            from Plan
                natural join Students
                natural left join Marks
            where Mark is null
        union
        select StudentId
        from Plan
            natural join Students
            natural left join Marks
        where Mark is null
        group by StudentId
        having Count(distinct CourseId) <= 2
    )
