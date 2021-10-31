select GroupName, CourseName
    from (
        select GroupId, CourseId
            from Groups, Courses
        except
        select GroupId, CourseId
            from Students, Courses
            where not exists (
                select Mark
                    from Marks
                    where Marks.StudentId = Students.StudentId
                        and Marks.CourseId = Courses.CourseId
            )
    ) GroupsUndebtedCourse, Groups, Courses
    where GroupsUndebtedCourse.GroupId = Groups.GroupId
        and GroupsUndebtedCourse.CourseId = Courses.CourseId
