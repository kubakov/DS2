-- 2-1
SELECT Course.Code, Course.Name
FROM Course
JOIN Teacher ON Course.teacher_login = Teacher.login
WHERE Teacher.fname = 'Jerry' AND Teacher.lname = 'Jordon';

-- 2-3
SELECT Student.login, Student.fname, Student.lname, COUNT(course_code) AS pocet
FROM Student
LEFT JOIN Studentcourse ON Student.login = Studentcourse.student_login
WHERE email LIKE '%@vsb.cz'
GROUP BY student.login, student.fname, student.lname

-- 2-4
SELECT Student.login, Student.fname, Student.lname, COUNT(DISTINCT Course.teacher_login) AS pocet
FROM Student
LEFT JOIN Studentcourse ON Student.login = Studentcourse.student_login AND Studentcourse.year = 2020
LEFT JOIN Course ON Studentcourse.course_code = Course.code
GROUP BY student.login, student.fname, student.lname

-- 2-6
WITH T AS(
    SELECT Teacher.login, Teacher.fname, Teacher.lname, COUNT(Course.code) AS pocet
    FROM Teacher
    LEFT JOIN Course ON Course.teacher_login = Teacher.login
    GROUP BY Teacher.login, Teacher.fname, Teacher.lname
)
SELECT *
FROM T
WHERE T.pocet = (SELECT MAX(T.pocet) FROM T)

-- 3-1
INSERT INTO Teacher (login, fname, lname, department) VALUES ('bur154', 'Peter', 'Burton', 'Department of Mathematic');

-- 3-3
DELETE FROM Studentcourse
WHERE Studentcourse.course_code IN(
    SELECT Course.code
    FROM Course
    JOIN Teacher ON Course.teacher_login = Teacher.login
    WHERE Teacher.fname = 'Carl' AND Teacher.lname = 'Artis'
)

-- 3-4
INSERT INTO StudentCourse (student_login, course_code, year)
SELECT (SELECT login FROM Student WHERE fname = 'Barbara' AND lname = 'Jones'),Course.code, 2021
FROM Teacher
JOIN Course ON Teacher.login = Course.teacher_login
WHERE Teacher.fname = 'Walter' AND Teacher.lname = 'Perryman'

-- 4-1
UPDATE Student
SET date_of_birth = TO_DATE('1997-03-02', 'yyyy-mm-dd')
WHERE login = 'smi324'

-- 4-2
SELECT login, fname, lname, FLOOR(MONTHS_BETWEEN(CURRENT_TIMESTAMP, date_of_birth) / 12) AS vek
FROM Student

-- 4-4
SELECT login, fname, lname, EXTRACT(YEAR FROM date_of_birth) AS rok, EXTRACT(MONTH FROM date_of_birth) AS mesic, EXTRACT(DAY FROM date_of_birth) AS den
FROM Student

-- 5-1
SELECT fname || ' ' || lname AS cele_jmeno
FROM Student