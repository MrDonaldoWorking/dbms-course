select GroupName, AvgAvgMark
    from Groups
        left join (select GroupId, avg(AvgMark) as AvgAvgMark
                from Students
                    left join (select StudentId, avg(cast(Mark as float)) as AvgMark
                            from Marks
                            group by StudentId
                        )
                        StudentAvgs
                    on Students.StudentId = StudentAvgs.StudentId
                    group by GroupId
            )
            GroupAvgs
        on Groups.GroupId = GroupAvgs.GroupId
