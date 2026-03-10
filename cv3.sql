-- 1-1
CREATE OR REPLACE PROCEDURE PPrint(p_text VARCHAR) AS
BEGIN
    dbms_output.put_line(p_text);
END;

----------

BEGIN
    PPrint('Ahoj');
END;

-- 1-2
CREATE OR REPLACE PROCEDURE PAddStudent(
    p_login STUDENT.login%TYPE, p_fname STUDENT.fname%TYPE, p_lname STUDENT.lname%TYPE,
    p_email STUDENT.email%TYPE, p_grade STUDENT.grade%TYPE, p_dateOfBirth STUDENT.date_of_birth%TYPE
) AS
BEGIN
    INSERT INTO Student (login, fname, lname, email, grade, date_of_birth)
    VALUES (p_login, p_fname, p_lname, p_email, p_grade, p_dateOfBirth);
END;

BEGIN
    PAddStudent('ked212', 'Petr', 'Ked', 'petr@vsb.cz', 1, TO_DATE('2002/11/05', 'yyyy/mm/dd'));
END;

-- 1-3
CREATE OR REPLACE PROCEDURE PAddStudent2(
    p_fname STUDENT.fname%TYPE, p_lname STUDENT.lname%TYPE,
    p_email STUDENT.email%TYPE, p_grade STUDENT.grade%TYPE,
    p_dateOfBirth STUDENT.date_of_birth%TYPE
) AS
    v_login STUDENT.login%TYPE := LOWER(SUBSTR(p_lname, 1, 3)) || '000';
BEGIN
    INSERT INTO Student (login, fname, lname, email, grade, date_of_birth)
    VALUES (v_login, p_fname, p_lname, p_email, p_grade, p_dateOfBirth);
END;

EXECUTE PAddStudent2 ('Jan', 'Novák', 'jan@vsb.cz', 2, TO_DATE('2003/02/06', 'yyyy/mm/dd'));

-- 1-4
CREATE OR REPLACE PROCEDURE PAddStudent3(
    p_fname STUDENT.fname%TYPE, p_lname STUDENT.lname%TYPE,
    p_email STUDENT.email%TYPE, p_grade STUDENT.grade%TYPE,
    p_dateOfBirth STUDENT.date_of_birth%TYPE
) AS
    v_login STUDENT.login%TYPE;
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM STUDENT;
    v_login := LOWER(SUBSTR(p_lname, 1, 3)) || LPAD(v_count+1, 3, '0');
    INSERT INTO Student (login, fname, lname, email, grade, date_of_birth)
    VALUES (v_login, p_fname, p_lname, p_email, p_grade, p_dateOfBirth);
END;

EXECUTE PAddStudent3 ('Petr', 'Novák', 'petr@vsb.cz', 2, TO_DATE('2003/03/06', 'yyyy/mm/dd'));

-- 2-1
CREATE OR REPLACE FUNCTION FAddStudent1(
    p_login STUDENT.login%TYPE, p_fname STUDENT.fname%TYPE, p_lname STUDENT.lname%TYPE,
    p_email STUDENT.email%TYPE, p_grade STUDENT.grade%TYPE, p_dateOfBirth STUDENT.date_of_birth%TYPE
) RETURN VARCHAR AS
BEGIN
    INSERT INTO Student (login, fname, lname, email, grade, date_of_birth)
    VALUES (p_login, p_fname, p_lname, p_email, p_grade, p_dateOfBirth);
    RETURN 'OK';
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR';
END;

DECLARE
    v_out VARCHAR(10);
BEGIN
    v_out := FAddStudent1(...);
    PPrint(v_out);
END;

-- 2-3
CREATE OR REPLACE FUNCTION FGetLogin(p_lname STUDENT.lname%TYPE) RETURN VARCHAR AS
    v_login STUDENT.login%TYPE;
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM STUDENT;
    v_login := LOWER(SUBSTR(p_lname, 1, 3)) || LPAD(v_count+1, 3, '0');
    RETURN v_login;
END;

BEGIN
    PPrint(FGetLogin('Petr'));
END;

-- 2-4
CREATE OR REPLACE FUNCTION FAddStudent3(
    p_fname STUDENT.fname%TYPE, p_lname STUDENT.lname%TYPE,
    p_email STUDENT.email%TYPE, p_grade STUDENT.grade%TYPE,
    p_dateOfBirth STUDENT.date_of_birth%TYPE
) RETURN VARCHAR AS
    v_login STUDENT.login%TYPE;
BEGIN
    v_login := FGetLogin(p_lname);
    INSERT INTO Student (login, fname, lname, email, grade, date_of_birth)
    VALUES (v_login, p_fname, p_lname, p_email, p_grade, p_dateOfBirth);
    RETURN v_login;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR';
END;

-- 3-1
CREATE OR REPLACE TRIGGER TInsertStudent AFTER INSERT ON STUDENT FOR EACH ROW
BEGIN
    PPrint(:new.login || ': ' || :new.fname || ' ' || :new.lname);
END;

EXECUTE PAddStudent3('Jan', 'Novak', 'jan.novak@vsb.cz', 1, TO_DATE('2000-01-01', 'yyyy-mm-dd'));

-- 3-2
CREATE OR REPLACE TRIGGER TDeleteStudent AFTER DELETE ON STUDENT FOR EACH ROW
BEGIN
    PPrint(:old.login || ': ' || :old.fname || ' ' || :old.lname);
END;

DELETE FROM STUDENT WHERE login = 'nov029'

-- 3-3
CREATE OR REPLACE TRIGGER TUpdateStudent AFTER UPDATE ON STUDENT FOR EACH ROW
BEGIN
    PPrint('OLD: ' || :old.fname || ' ' || :old.lname || ', ' || :old.grade);
    PPrint('NEW: ' || :new.fname || ' ' || :new.lname || ', ' || :new.grade);
END;

UPDATE Student
SET grade = grade + 1
WHERE login IN ('mcc676', 'kow007');

-- 3-4
CREATE OR REPLACE TRIGGER TInsertStudent1 AFTER INSERT ON STUDENT FOR EACH ROW
BEGIN
    INSERT INTO STUDENTCOURSE(student_login, course_code, year)
    SELECT :new.login, code, EXTRACT(YEAR FROM CURRENT_TIMESTAMP)
    FROM COURSE
    WHERE GRADE = 1;
END;