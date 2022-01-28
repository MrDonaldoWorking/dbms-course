merge into Marks M
    using NewMarks NM
    on M.StudentId = NM.StudentId and M.CourseId = NM.CourseId
    when matched and NM.Mark > M.Mark then
        update set M.Mark = NM.Mark
    when not matched then
        insert (StudentId, CourseId, Mark)
            values
            (NM.StudentId, NM.CourseId, NM.Mark)
