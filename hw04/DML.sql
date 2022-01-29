insert into Groups (group_id, group_name)
    values
    (1, 'M34342'),
    (2, 'M34351'),
    (3, 'M34361');

insert into Students (student_id, student_name, group_id)
    values
    (1, 'Ота Никита', 1),
    (2, 'Паночевных Демид', 2),
    (3, 'Кочергин Даниил', 3);

insert into Courses (course_id, course_name)
    values
    (1, 'Дискретная математика'),
    (2, 'Алгоритмы и структуры данных'),
    (3, 'Математический анализ');

insert into Lecturers (lecturer_id, lecturer_name)
    values
    (1, 'Станкевич Андрей'),
    (2, 'Нигматуллин Нияз'),
    (3, 'Кохась Константин');

insert into CourseGroups (group_id, course_id, lecturer_id)
    values
    (1, 1, 2),
    (2, 2, 3),
    (3, 3, 1);

insert into Marks (student_id, course_id, mark_name)
    values
    (1, 3, 'A'),
    (2, 1, 'B'),
    (3, 2, 'C');
