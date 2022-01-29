# Домашнее задание 8. Индексирование 😱

## 1. Запросы из предыдущих ДЗ

Для каждой таблицы укажите объявления индексов на языке SQL (create index, в одну строку). Перед каждым индексом в комментарии (--) укажите обоснование типа индекса и номера запросов, которые он ускорит в формате "ДЗ-X.Y.Z. Формулировка задания", по одному на строке. Если индекс ускоряет много запросов, достаточно указать три из них. Между объявлением индекса и комментарием к следующему индексу оставьте пустую строку. Комментарии длиннее 70 символов разбивайте на несколько строк.

### 1.S. Индексы на таблицу Students

#### Минусы
Синтаксическая ошибка: 7:0: extraneous input 'cteate' expecting {<EOF>, CREATE, WS}

Не unique индекс (а должен): create index SNameIndex on Students using hash (StudentName, StudentId);

Индекс мало/бесполезен: ДЗ-5.8.1 для create unique index SIdIndex on Students using hash (StudentId);

Индекс мало/бесполезен: ДЗ-5.1.2 для create index SNameIndex on Students using hash (StudentName, StudentId);

Индекс мало/бесполезен: ДЗ-5.2.2 для create index SNameIndex on Students using hash (StudentName, StudentId);

Индекс мало/бесполезен: ДЗ-6.1.1 для create index SNameIndex on Students using hash (StudentName, StudentId);

Индекс мало/бесполезен: ДЗ-5.2.1 для create index GIdIndex on Students using hash (GroupId);

Индекс мало/бесполезен: ДЗ-5.2.2 для create index GIdIndex on Students using hash (GroupId);

Приведено недостаточно примеров (хотя они существуют): create index GIdIndex on Students using hash (GroupId);

### 1.G. Индексы на таблицу Groups

#### Минусы
Нет индекса на PK: create unique index on Groups using hash (GroupName);

Приведено недостаточно примеров (хотя они существуют): create unique index GIdIndex on Groups using hash (GroupId);

Индекс мало/бесполезен: ДЗ-6.1.2 для create unique index GNameIndex on Groups using hash (GroupName, GroupId);

Индекс мало/бесполезен: ДЗ-7.2.4 для create unique index GNameIndex on Groups using hash (GroupName, GroupId);

Индекс мало/бесполезен: ДЗ-7.2.5 для create unique index GNameIndex on Groups using hash (GroupName, GroupId);

### 1.C. Индексы на таблицу Courses

#### Минусы
Не unique индекс (а должен): create index CNameIndex on Courses using hash (CourseName, CourseId);

Ожидался покрывающий индекс вместо: create index CNameIndex on Courses using hash (CourseName, CourseId);

Индекс мало/бесполезен: ДЗ-5.3.2 для create unique index CIdIndex on Courses using hash (CourseId);

Индекс мало/бесполезен: ДЗ-5.4.1 для create unique index CIdIndex on Courses using hash (CourseId);

Приведено недостаточно примеров (хотя они существуют): create unique index CIdIndex on Courses using hash (CourseId);

Индекс мало/бесполезен: ДЗ-5.3.2 для create index CNameIndex on Courses using hash (CourseName, CourseId);

Индекс мало/бесполезен: ДЗ-5.4.1 для create index CNameIndex on Courses using hash (CourseName, CourseId);

### 1.L. Индексы на таблицу Lecturers

#### Минусы
Неизвестная таблица или столбец в индексе: create unique index LIdIndex on Lecturers using hash (LecturersId);

Неизвестная таблица или столбец в индексе: create index LNameIndex on Lecturers using hash (LecturersName, LecturersId);

Нет индекса на PK: create unique index on Lecturers using hash (LecturerId);

Не хватает индекса: create index on Lecturers using btree (LecturerName, LecturerId);

### 1.P. Индексы на таблицу Plan

#### Минусы
Синтаксическая ошибка: 1:0: extraneous input 'cteate' expecting {<EOF>, CREATE, WS}

Не unique индекс (а должен): create index CGIndex on Plan using btree (CourseId, GroupId);

Не unique индекс (а должен): create index GCIndex on Plan using btree (GroupId, CourseId);

Индекс мало/бесполезен: ДЗ-5.6.3 для create index CGIndex on Plan using btree (CourseId, GroupId);

Индекс мало/бесполезен: ДЗ-5.6.4 для create index CGIndex on Plan using btree (CourseId, GroupId);

Индекс мало/бесполезен: ДЗ-5.10 для create index CGIndex on Plan using btree (CourseId, GroupId);

Индекс мало/бесполезен: ДЗ-5.6.3 для create index GCIndex on Plan using btree (GroupId, CourseId);

### 1.M. Индексы на таблицу Marks

#### Минусы
Упорядоченный индекс на префикс другого упорядоченного индекса: create index SCIndex on Marks using btree (StudentId, CourseId); create index CSIndex on Marks using btree (StudentId, CourseId);

Упорядоченный индекс на префикс другого упорядоченного индекса: create index CSIndex on Marks using btree (StudentId, CourseId); create index SCIndex on Marks using btree (StudentId, CourseId);

Не unique индекс (а должен): create index SCIndex on Marks using btree (StudentId, CourseId);

Не unique индекс (а должен): create index CSIndex on Marks using btree (StudentId, CourseId);

Ожидался покрывающий индекс вместо: create index MarkIndex on Marks using hash (Mark, CourseId);

Не хватает индекса: create index on Marks using hash (CourseId);

Индекс мало/бесполезен: ДЗ-5.6.4 для create index SCIndex on Marks using btree (StudentId, CourseId);

Индекс мало/бесполезен: ДЗ-5.6.4 для create index CSIndex on Marks using btree (StudentId, CourseId);

Индекс мало/бесполезен: ДЗ-5.3.1 для create index MarkIndex on Marks using hash (Mark, CourseId);

Индекс мало/бесполезен: ДЗ-5.3.2 для create index MarkIndex on Marks using hash (Mark, CourseId);

Индекс мало/бесполезен: ДЗ-5.3.3 для create index MarkIndex on Marks using hash (Mark, CourseId);

## 2. Статистический запрос

### 2.Q. Запрос

Пусть частым запросом является определение среднего балла студентов группы по дисциплине. Как будет выглядеть запрос и какие индексы могут помочь при его исполнении?

#### Минусы
SQL: Использование exists/in/скалярных подзапросов: 2

SQL: Слишком много подзапросов: 3

### 2.I. Индексы

#### Минусы
Не хватает индекса: create index on Students using hash (GroupId);

Неэффективный или бесполезный индекс: create index SIdIndex on Students using hash (StudentId);

Не хватает индекса: create index on Marks using btree (CourseId, StudentId, Mark);

Неэффективный или бесполезный индекс: create index SIdIndex on Marks using hash (StudentId);

Unique индекс (а не должен): create unique index GNameIndex on Groups using hash (GroupName, GroupId);

Unique индекс (а не должен): create unique index CNameIndex on Courses using hash (CourseName, CourseId);

Ожидался покрывающий индекс вместо: create unique index CNameIndex on Courses using hash (CourseName, CourseId);

## 3. Новые запросы

Придумайте три запроса, требующих новых индексов и запишите их. Если в результате, некоторые из старых индексов станут бесполезными, удалите их.

### 3.1.Q. Запрос 1

#### Минусы
Не хватает пробела в like 'prefix %'

### 3.1.I. Дополнительные индексы для запроса 1

### 3.2.Q. Запрос 2

#### Минусы
Бесполезный запрос или индекс

### 3.2.I. Дополнительные индексы для запроса 2

#### Минусы
Ожидалось, что такой индекс будет обявлен в первом разделе: Students using btree (StudentName)

### 3.3.Q. Запрос 3

### 3.3.I. Дополнительные индексы для запроса 3


## **Примечание**

При выполнении задания считайте, что ФЗ соответствуют полученным в ДЗ-3 и 4. 
