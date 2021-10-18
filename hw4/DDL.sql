create table Groups (
    group_id int primary key not null,
    group_name varchar(30) unique not null
);

create table Students (
    student_id int primary key not null,
    student_name varchar(60) not null,
    group_id int not null,
    foreign key (group_id) references Groups (group_id)
);
    
create table Courses (
    course_id int primary key not null,
    course_name varchar(100) not null
);

create table Marks (
    student_id int not null,
    course_id int not null,
    mark_name char not null,
    primary key (student_id, course_id),
    foreign key (student_id) references Students (student_id),
    foreign key (course_id) references Courses (course_id)
);

create table Lecturers (
    lecturer_id int primary key not null,
    lecturer_name varchar(60) not null
);

create table CourseGroups (
    group_id int not null,
    course_id int not null,
    lecturer_id int not null,
    primary key (group_id, course_id),
    foreign key (group_id) references Groups (group_id),
    foreign key (course_id) references Courses (course_id),
    foreign key (lecturer_id) references Lecturers (lecturer_id)
);
