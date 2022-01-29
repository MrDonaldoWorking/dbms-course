insert into Groups
(group_id, group_name)
values
(1, 'M34342'),
(2, 'M34351'),
(3, 'M34361');

insert into Students
(student_id, first_name, last_name, group_id)
values
(1, 'Никита', 'Ота', 1),
(2, 'Евгений', 'Кононов', 2),
(3, 'Андрей', 'Бочарников', 3);
	
insert into Tutors
(tutor_id, first_name, last_name)
values
(1, 'Георгий', 'Корнеев'),
(2, 'Андрей', 'Станкевич'),
(3, 'Константин', 'Кохась');

insert into Subjects
(subject_id, subject_name)
values
(1, 'Введение в программирование'),
(2, 'Дискретная математика'),
(3, 'Математический анализ', 1);
	
insert into TutorSubjects
(subject_id, tutor_id)
values
(1, 1),
(2, 2),
(3, 3);

insert into GroupSubjects
(subject_id, group_id)
values
(1, 1),
(1, 2),
(1, 3),
(2, 2),
(2, 3),
(3, 3);
	
insert into Marks
(student_id, subject_id, mark)
values
(1, 1, 100),
(1, 2, 74.5),
(3, 1, 70),
(2, 3, 98);
