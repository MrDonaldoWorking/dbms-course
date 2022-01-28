Дано отношение с атрибутами StudentId, StudentName, GroupId, GroupName, CourseId, CourseName, LecturerId, LecturerName, Mark.

1. Инкрементально приведите данное отношение в пятую нормальную форму.
2. Постройте соответствующую модель сущность-связь.
3. Постройте соответствующую физическую модель.
4. Реализуйте SQL-скрипты, создающие схему базы данных.
5. Создайте базу данных по спроектированной модели.
6. Заполните базу тестовыми данными. 

## Минусы

1. НФ-1
2. НФ- 2
Комментарий: not every decomposition order preserves FDs
Распавшаяся ФЗ: CourseId GroupId -> LecturerId в Decomposition([CourseId, CourseName, GroupId, GroupName, LecturerId, LecturerName, Mark, StudentId, StudentName] => [GroupId, GroupName, StudentId, StudentName]; [CourseId, CourseName]; [CourseId, LecturerId, LecturerName, Mark, StudentId])
3. НФ- 3
Неверная декомпозиция: decomposition cannot create new attributes (GroupId)
Новый атрибут в результате декомпозиции: GroupId в Decomposition([CourseId, LecturerId, LecturerName, Mark, StudentId] => [GroupId, LecturerId, StudentId]; [LecturerId, LecturerName]; [CourseId, Mark, StudentId])
Не в 3NF: StudentId -> GroupId в [GroupId, LecturerId, StudentId]
B. НФБК
Не в 3NF: StudentId -> GroupId в [GroupId, LecturerId, StudentId]
4. НФ- 4
Не приведены контрпримеры демонстрирующие отсутствие ФЗ/МЗ/ЗС
Не в 3NF: StudentId -> GroupId в [GroupId, LecturerId, StudentId]
5. НФ- 5
Не приведены контрпримеры демонстрирующие отсутствие ФЗ/МЗ/ЗС
Не в 3NF: StudentId -> GroupId в [GroupId, LecturerId, StudentId]
6. Модели
    6.1. Сущность-связь
    Отсутствует ключ (обычно на GroupName): GroupName
    Не соответствует полученным отношениям: Не соответствуют (StudentId, GroupId, LecturerId), CourseGroup
    6.2. Физическая
7. SQL
    7.1. DDL
    7.2. DML
