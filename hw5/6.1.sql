select distinct StudentId from Plan natural join Lecturers natural join Marks natural join Students where LecturerName = :LecturerName
