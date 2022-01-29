-- Salute to Che!
select distinct StudentId,
                count(distinct CourseId)               as Total,
                count(Mark)                            as Passed,
                count(distinct CourseId) - count(Mark) as Failed
from Students
         left join (select GroupId, CourseId from Plan) query using (GroupId)
         left join Marks using (StudentId, CourseId)
group by StudentId
