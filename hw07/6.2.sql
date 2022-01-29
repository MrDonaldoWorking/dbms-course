-- Big Brother Kirpich is watching you..
create assertion assert
check
(
  select not exists
  (
  select * from Marks bm
    natural join Students bs
    natural join Groups bg
  where 
    exists
    (
      select * from Students S
      where S.GroupId = bg.GroupId and S.StudentId not in 
      (
         select StudentId from Marks
         where bm.CourseId = Marks.CourseId
      )
    )
  )
)
