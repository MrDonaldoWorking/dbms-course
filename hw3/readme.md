 
### Домашнее задание 3. Функциональные зависимости в БД «Университет»

Дано отношение с атрибутами
_StudentId_,
_StudentName_,
_GroupId_,
_GroupName_,
_CourseId_,
_CourseName_,
_LecturerId_,
_LecturerName_,
_Mark_.

1.              Найдите функциональные зависимости в данном отношении.

2.              Найдите все ключи данного отношения.

3.              Найдите замыкание множеств атрибутов:

    1.  _GroupId_, _CourseId_;
    2.  _StudentId_, _CourseId_;
    3.  _StudentId_, _LecturerId_.
4.              Найдите неприводимое множество функциональных зависимостей
                для данного отношения.


[Форма для сдачи ДЗ](https://docs.google.com/forms/d/e/1FAIpQLSd1h_b9m5zdknN89Aa_uf0MDTNEmuRb5LNyq1ORn0ECe33QyQ/viewform)

В рамках проекта:

1.              Определите набор атрибутов, необходимых для проекта,
                и определите отношения на них.

2.  Найдите функциональные зависимости полученных отношений.
3.  Найдите все ключи полученных отношений.
4.              Найдите неприводимые множества функциональных зависимостей
                для полученных отношений.

## Минусы

1. Функциональные зависимости
Пропущена ФЗ: GroupName -> GroupId
### Я тут сам не понял, почему так нужно, но Гоше виднее ###

2. Ключи
Указанные утверждения не верны: Key K = {X1, X2, ..., Xn} should satisfy K+(on fun. dep.) = A -- all attributes
Не надключ: [StudentId]
Не надключ: [CourseId]
Пропущен ключ: [CourseId, StudentId]

3. Замыкания множеств атрибутов
    3.1. Замыкание множества атрибутов GroupId , CourseId
    Нельзя получить из предыдущего множества за один шаг: [CourseId, CourseName, GroupId, GroupName, LecturerId, LecturerName]
    3.2. Замыкание множества атрибутов StudentId , CourseId
    Нельзя получить из предыдущего множества за один шаг: [CourseId, CourseName, GroupId, GroupName, LecturerId, LecturerName, Mark, StudentId, StudentName]
    3.3. Замыкание множества атрибутов StudentId , LecturerId
    Нельзя получить из предыдущего множества за один шаг: [GroupId, GroupName, LecturerId, LecturerName, StudentId, StudentName]

4. Неприводимое множество функциональных зависимостей
    4.1. Первый этап
    4.2. Второй этап
    Указанные утверждения не верны: If Y belongs to X+ (on S) then X, A -> Y can be replaced as X -> Y
    4.3. Третий этап
