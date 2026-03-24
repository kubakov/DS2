-- 1-1
CREATE OR REPLACE PROCEDURE PAddStudentToCourse(
    p_student_login STUDENT.login%TYPE, p_course_code STUDENTCOURSE.course_code%TYPE, p_year STUDENTCOURSE.year%TYPE
) AS
    v_cap INT;
    v_cnt INT;
BEGIN
    SELECT capacity INTO v_cap
    FROM COURSE
    WHERE code = p_course_code;
    
    SELECT COUNT(*) INTO v_cnt
    FROM STUDENTCOURSE
    WHERE course_code = p_course_code AND year = p_year;
    
    IF v_cnt < v_cap THEN
        INSERT INTO STUDENTCOURSE (student_login, course_code, year)
        VALUES (p_student_login, p_course_code, p_year);
    ELSE
        PPrint('Kurz je již plně obsazen');
    END IF;
END;

-- 1-2
CREATE OR REPLACE TRIGGER TInsertStudentCourse BEFORE INSERT ON STUDENTCOURSE FOR EACH ROW
DECLARE
    v_cap INT;
    v_cnt INT;
BEGIN
    SELECT capacity INTO v_cap
    FROM COURSE
    WHERE code = :new.course_code;
    
    SELECT COUNT(*) INTO v_cnt
    FROM STUDENTCOURSE
    WHERE course_code = :new.course_code AND year = :new.year;
    
    IF v_cnt > v_cap THEN
        PPrint('Kurz je již plně obsazen');
    END IF;
END;

-- 1-3
CREATE OR REPLACE TRIGGER TInsertStudentCourse BEFORE INSERT ON STUDENTCOURSE FOR EACH ROW
DECLARE
    v_cap INT;
    v_cnt INT;
    v_ex EXCEPTION;
BEGIN
    SELECT capacity INTO v_cap
    FROM COURSE
    WHERE code = :new.course_code;
    
    SELECT COUNT(*) INTO v_cnt
    FROM STUDENTCOURSE
    WHERE course_code = :new.course_code AND year = :new.year;
    
    IF v_cnt > v_cap THEN
        PPrint('Kurz je již plně obsazen');
        RAISE v_ex;
    END IF;
END;

-- 2-1
CREATE OR REPLACE FUNCTION FLoginExists(p_login STUDENT.login%TYPE) RETURN BOOLEAN AS
    v_cnt INT;
BEGIN
    SELECT COUNT(*) INTO v_cnt
    FROM STUDENT
    WHERE login = p_login;
    
    IF v_cnt > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

-- 2-2
CREATE OR REPLACE FUNCTION FGetNextLogin(p_lname STUDENT.lname%TYPE) RETURN VARCHAR AS
    v_i INT;
    v_login STUDENT.login%TYPE;
BEGIN
    v_i := 1;
    LOOP
        v_login := LOWER(SUBSTR(p_lname, 1, 3)) || LPAD(v_i, 3, '0');
        EXIT WHEN NOT FLoginExists(v_login);
        v_i := v_i + 1;
    END LOOP;
    RETURN v_login;
END;

SELECT fgetnextlogin('novak')
FROM Dual;

-- 3-1
DECLARE
    v_fname Student.fname%TYPE;
    v_lname Student.lname%TYPE;
    CURSOR c_student IS SELECT fname, lname FROM Student;
BEGIN
    OPEN c_student;
    
    LOOP
        EXIT WHEN c_student%NOTFOUND;
        FETCH c_student INTO v_fname, v_lname;
        
        PPrint(v_fname || ' ' || v_lname);
    END LOOP;
    
    CLOSE c_student;
END;


BEGIN
    FOR c_student IN (SELECT fname, lname FROM Student) LOOP
        PPrint(c_student.fname || ' ' || c_student.lname);
    END LOOP;
END;

-- 3-3
CREATE OR REPLACE FUNCTION FExportPointsCSV(p_year INT) RETURN VARCHAR AS
    v_ret VARCHAR(2000) := '';
BEGIN
    FOR c_student IN (
        SELECT Student.login, Student.fname, Student.lname, SUM(StudentCourse.points) AS pts
        FROM Student JOIN StudentCourse ON Student.login = StudentCourse.student_login
        WHERE year = p_year
        GROUP BY Student.login, Student.fname, Student.lname
    ) LOOP
        IF v_ret IS NOT NULL THEN
            v_ret := v_ret || CHR(13) || CHR(10);
        END IF;
        v_ret := v_ret || c_student.login || ',' || c_student.fname || ',' || c_student.lname || ',' || c_student.pts;            
    END LOOP;
    RETURN v_ret;
END;

BEGIN
    dbms_output.put_line(FExportPointsCSV(2021));
END;
