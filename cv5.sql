-- 1-1
CREATE OR REPLACE PROCEDURE PPrepareTableReward AS
    v_sql VARCHAR(1000);
    v_cnt INT;
BEGIN
    SELECT COUNT(*) INTO v_cnt
    FROM USER_TABLES
    WHERE table_name = 'REWARD';
    
    IF v_cnt > 0 THEN
        v_sql := 'DROP TABLE REWARD';
        EXECUTE IMMEDIATE v_sql;
    END IF;

    v_sql := '
        CREATE TABLE REWARD
        (
            id INTEGER PRIMARY KEY,
            student_login CHAR(6) REFERENCES STUDENT,
            winter_reward INTEGER NULL,
            summer_reward INTEGER NULL,
            thesis_reward INTEGER NULL
        )';
        
    EXECUTE IMMEDIATE v_sql;
END;

BEGIN
    PPrepareTableReward;
END;

-- 1-2
CREATE OR REPLACE PROCEDURE PSetStudentReward(p_login STUDENT.login%TYPE, p_rewardType VARCHAR, p_reward INT) AS
    v_sql VARCHAR(1000);
    v_id INT;
BEGIN
    SELECT COALESCE(MAX(ID),0) + 1 INTO v_id
    FROM REWARD;

    v_sql := 'INSERT INTO REWARD(id, student_login, ' || p_rewardType || ' p_reward)
            VALUES(:1, :2, :3)';
    
    EXECUTE IMMEDIATE v_sql USING v_id, p_login, p_reward;
END;

CREATE OR REPLACE FUNCTION FGetStudentInfo(p_login STUDENT.login%TYPE, p_attribute VARCHAR) RETURN VARCHAR AS
    v_sql VARCHAR(1000);
    v_ret VARCHAR(100);
BEGIN
    v_sql := 'SELECT ' || p_attribute || '
            FROM STUDENT
            WHERE STUDENT.login = :1';
            
    EXECUTE IMMEDIATE v_sql INTO v_ret USING p_login;
    RETURN v_ret;
END;

SELECT FGetStudentInfo('ked212', 'email')
FROM DUAL;