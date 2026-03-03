-- 1
BEGIN
    dbms_output.put_line('Hello world');
END;

-- 2
DECLARE
    v_login STUDENT.login%TYPE;
    v_fname STUDENT.fname%TYPE;
    v_lname STUDENT.lname%TYPE;
    v_email STUDENT.email%TYPE := 'petr.novak@vsb.cz';
    v_grade STUDENT.grade%TYPE := 1;
    v_date_of_birth STUDENT.date_of_birth%TYPE := TO_DATE('1992/05/06', 'yyyy/mm/dd');
BEGIN
    v_login := 'abc123';
    v_fname := 'Petr';
    v_lname := 'Novak';
    
    INSERT INTO Student (login, fname, lname, email, grade, date_of_birth)
    VALUES (v_login, v_fname, v_lname, v_email, v_grade, v_date_of_birth);
    dbms_output.put_line('Student byl vložen');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Student nebyl vložen');
END;

DECLARE
    v_login STUDENT.login%TYPE;
    v_fname STUDENT.fname%TYPE;
    v_lname STUDENT.lname%TYPE;
    v_email STUDENT.email%TYPE;
    v_grade STUDENT.grade%TYPE;
    v_date_of_birth STUDENT.date_of_birth%TYPE;
BEGIN
    SELECT login, fname, lname, email, grade, date_of_birth
    INTO v_login, v_fname, v_lname, v_email, v_grade, v_date_of_birth
    FROM STUDENT
    WHERE login = 'abc123';
    
    dbms_output.put_line('login: ' || v_login);
    dbms_output.put_line('jmeno: ' || v_fname);
    dbms_output.put_line('prijmeni: ' || v_lname);
    dbms_output.put_line('mail: ' || v_email);
END;

-- 3
DECLARE
    v_student STUDENT%ROWTYPE;
BEGIN
    SELECT *
    INTO v_student
    FROM STUDENT
    WHERE login = 'abc123';
    
    dbms_output.put_line('login: ' || v_student.login);
    dbms_output.put_line('jmeno: ' || v_student.fname);
    dbms_output.put_line('prijmeni: ' || v_student.lname);
    dbms_output.put_line('mail: ' || v_student.email);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Žádná data');
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Moc řádků');
END;

-- 4
BEGIN
    INSERT INTO Student (login, fname, lname, email, grade, date_of_birth)
    VALUES ('aaa111', 'Adam', 'A', 'adam@mail.com', 1, TO_DATE('1998/03/02', 'yyyy/mm/dd'));
    
    INSERT INTO Student (login, fname, lname, email, grade, date_of_birth)
    VALUES ('aaa222', 'Petr', 'B', 'petr@mail.com', 1, TO_DATE('2000/04/05', 'yyyy/mm/dd'));
    COMMIT;
    dbms_output.put_line('OK');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Chyba');
END;

-- DU1
DECLARE
    v_student STUDENT%ROWTYPE;
    v_studentCourse STUDENTCOURSE%ROWTYPE;
    v_course COURSE%ROWTYPE;
    v_teacher TEACHER%ROWTYPE;
BEGIN
    v_student.login := 'bbb111';
    v_student.fname := 'Jan';
    v_student.lname := 'C';
    v_student.email := 'jan@mail.com';
    v_student.grade := 1;
    v_student.date_of_birth := TO_DATE('2000/01/05', 'yyyy/mm/dd');
    
    v_studentCourse.student_login := 'bbb111';
    v_studentCourse.course_code := '450-aa2-122';
    v_studentCourse.year := 2026;
    
    v_teacher.login := 'ddd222';
    v_teacher.fname := 'Petra';
    v_teacher.lname := 'D';
    v_teacher.department := 'Department of CS';
    
    v_course.code := '450-aa2-122';
    v_course.name := 'jmeno';
    v_course.capacity := 20;
    v_course.teacher_login := 'ddd222';
    
    INSERT INTO Student (login, fname, lname, email, grade, date_of_birth)
    VALUES (v_student.login, v_student.fname, v_student.lname, v_student.email, v_student.grade, v_student.date_of_birth);
    
    INSERT INTO Teacher (login, fname, lname, department)
    VALUES (v_teacher.login, v_teacher.fname, v_teacher.lname, v_teacher.department);
    
    INSERT INTO Course (code, name, capacity, teacher_login)
    VALUES (v_course.code, v_course.name, v_course.capacity, v_course.teacher_login);
    
    INSERT INTO StudentCourse (student_login, course_code, year)
    VALUES (v_studentCourse.student_login, v_studentCourse.course_code, v_studentCourse.year);
    
    dbms_output.put_line('OK');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Chyba');
END;