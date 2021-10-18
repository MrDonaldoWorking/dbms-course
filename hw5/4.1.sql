select * from Students except select StudentId, StudentName, GroupId from Courses natural join Marks natural join Students where CourseName = :CourseName
