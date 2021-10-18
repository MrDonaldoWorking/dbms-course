# Реляционная алгебра и SQL-запросы

## 1. Информация о студенте
(StudentId, StudentName, GroupId)

### 1.1. С заданным :StudentId

#### Example
 :StudentId = 1

### 1.2. С заданным :StudentName

#### Example
 :StudentName = 'Петров П.П.'

## 2. Полная информация о студенте
(StudentId, StudentName, GroupName)

### 2.1. С заданным :StudentId

#### Example
 :StudentId = 1

### 2.2. С заданным :StudentName

#### Example
 :StudentName = 'Петров П.П.'


## 3. Информация о студентах с заданной оценкой (:Mark)
(StudentId, StudentName, GroupId)

### 3.1. По предмету с заданным :CourseId

#### Example
 :CourseId = 1

#### Example
 :Mark = 5

### 3.2. По предмету с заданным :CourseName

#### Example
 :CourseName = 'Базы данных'

#### Example
 :Mark = 4

### 3.3. По предмету, который у него вел :LecturerId

#### Example
 :LecturerId = 1

#### Example
 :Mark = 4

### 3.4. По предмету, который у него вел :LecturerName

#### Example
 :LecturerName = 'Корнеев Г.А.'

#### Example
 :Mark = 4

### 3.5. По предмету, который у кого-либо вел :LecturerId

#### Example
 :LecturerId = 1

#### Example
 :Mark = 4

### 3.6. По предмету, который у кого-либо вел :LecturerName

#### Example
 :LecturerName = 'Корнеев Г.А.'

#### Example
 :Mark = 4


## 4. Информацию о студентах не имеющих оценки по предмету :CourseName
(StudentId, StudentName, GroupId)

### 4.1. Среди всех студентов

#### Example
 :CourseName = 'Базы данных'

### 4.2. Среди студентов, у которых есть этот предмет


## 5. Для каждого студента ФИО и названия предметов
(StudentName, CourseName)

### 5.1. Которые у него есть по плану

### 5.2. Которые у него есть по плану, но у него нет оценки

### 5.3. Которые у него есть по плану, но у него не 4 или 5


## 6. Идентификаторы студентов по преподавателю :LecturerName
(StudentId)

### 6.1. Имеющих хотя бы одну оценку у преподавателя

#### Example
 :LecturerName = 'Корнеев Г.А.'

### 6.2. Не имеющих ни одной оценки у преподавателя

#### Example
 :LecturerName = 'Корнеев Г.А.'

### 6.3. Имеющих оценки по всем предметам преподавателя

#### Example
 :LecturerName = 'Корнеев Г.А.'

### 6.4. Имеющих оценки по всем предметам преподавателя, которые он вёл у этого студента

#### Example
 :LecturerName = 'Корнеев Г.А.'


## 7. Группы и предметы, такие что все студенты группы сдали предмет

### 7.1. Идентификаторы (GroupId, CourseId)

### 7.2. Названия (GroupName, CourseName)



# SQL-запросы

## 8. Суммарные баллы

### 8.1. Суммарный балл :StudentId
(SumMark)

#### Example
 :StudentId = 3

### 8.2. Суммарный балл каждого студента
(StudentName, SumMark)

### 8.3. Суммарный балл студентов каждой группы
(GroupName, SumMark)

## 9. Средние баллы

### 9.1. Средний балл :StudentId
(AvgMark)

#### Example
 :StudentId = 3

### 9.2. Средний балл каждого студента
(StudentName, AvgMark)

### 9.3. Средний балл каждой группы
(GroupName, AvgMark)

### 9.4. Средний балл средних баллов студентов каждой группы
(GroupName, AvgAvgMark)


## 10. Статистика по студентам
(StudentId, Total, Passed, Failed)
