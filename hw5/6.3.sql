select StudentId
    from Marks
        left join Plan
    on Plan.CourseId = Marks.CourseId
except
select StudentId
    from (select StudentId, CourseId
            from (select StudentId
                    from Marks
                        left join Plan
                    on Marks.CourseId = Plan.CourseId
                )
                AllStudentsWithMarks
                cross join (select CourseId
                    from Lecturers
                        natural join Plan
                    where LecturerName = :LecturerName
                )
                LecturerCourses
        except
        select StudentId, Plan.CourseId
            from Marks
                left join Plan
            on Marks.CourseId = Plan.CourseId
    )
    Divisor
