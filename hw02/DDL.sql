create table Students (
	student_id int primary key not null,
	first_name varchar(30) not null,
	last_name varchar(30) not null,
	group_id int not null
);

create table Groups (
	group_id int primary key not null,
	group_name varchar(10) not null
);

create table Subjects (
	subject_id int primary key,
	subject_name varchar(100) not null,
);

create table Grades (
	student_id int not null,
	subject_id int not null,
	mark float not null,
	primary key (student_id, subject_id)
);

create table Tutors (
	_id int primary key not null,
	first_name varchar(30) not null,
	last_name varchar(30) not null,
);

create table GroupSubjects (
	group_id int not null,
	subject_id int not null,
	primary key (group_id, subject_id)
);

create table TutorSubjects (
	tutor_id int not null,
	subject_id int not null,
	primary key (tutor_id, subject_id)
);

alter table Students
	add foreign key (group_id) references Groups (group_id);

alter table Groups
    add constraint unique_group_names unique (group_name);

alter table Grades
	add foreign key (student_id) references Students (student_id),
	add foreign key (subject_id) references Subjects (subject_id),
	add constraint mark_bound check (mark >= 0 and mark <= 100);

alter table GroupSubjects
	add foreign key (group_id) references Groups (group_id),
	add foreign key (subject_id) references Subjects (subject_id);

alter table TutorSubjects
	add foreign key (subject_id) references Subjects (subject_id),
	add foreign key (tutor_id) references Tutors (tutor_id); 
