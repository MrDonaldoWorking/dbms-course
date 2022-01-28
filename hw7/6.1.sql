create assertion assert
check (
  false = not exists (
  select StudentId, CourseId
    from Marks
      natural join Students
  except
    select StudentId, CourseId
    from Plan
      natural join Students)
)
