select GroupName, SumMark
    from Groups 
        left join (select GroupId, sum(StudentSumMark) as SumMark
            from Students
                natural join (select StudentId, sum(Mark) as StudentSumMark
                        from Marks
                        group by StudentId
                )
                Sums
                group by GroupId
        )
        StudentSums
    on StudentSums.GroupId = Groups.GroupId;
