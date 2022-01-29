select CourseId, GroupId
    from Marks
        cross join Students
    where Mark is not null
except
select CourseId, GroupId
    from (select CourseId, StudentId, GroupId
            from Students
                cross join (select CourseId from Marks) MarksCourses
        except
        select CourseId, StudentId, GroupId
            from Marks
                natural join Students
    )
    Divisor
