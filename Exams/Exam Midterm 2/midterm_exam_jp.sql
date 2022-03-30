----------------- Q1 A

connect des03/des03;

CREATE OR REPLACE FUNCTION pontbriand_f1 (p_bday DATE) RETURN NUMBER AS
v_age NUMBER;
BEGIN
v_age := FLOOR((sysdate - p_bday)/365.25);
RETURN v_age;
END;
/
show error

----------------- Q1 B

SELECT pontbriand_f1 ('1992-04-6') FROM dual;

----------------- Q1 C

CREATE OR REPLACE PROCEDURE pontbriand_p1 (p_s_id NUMBER, p_c_sec_id NUMBER, p_grade CHAR) AS

v_f_id NUMBER;
v_last VARCHAR(20);
v_first VARCHAR(20);
v_bday DATE;
v_age NUMBER;
v_grade CHAR(1);

v_flag NUMBER := 0;

BEGIN

SELECT s_last, s_first, s_dob
INTO v_last, v_first, v_bday
FROM student 
WHERE p_s_id = s_id;

v_flag := 1;

SELECT f_id
INTO v_f_id
FROM course_section 
WHERE p_c_sec_id = c_sec_id;

v_flag := 2;

SELECT grade
INTO v_grade
FROM ENROLLMENT
WHERE s_id = p_s_id AND c_sec_id = p_c_sec_id;

IF v_grade = p_grade THEN
DBMS_OUTPUT.PUT_LINE('No need to update my friend abdul!');
ELSE

    v_age := pontbriand_f1(v_bday);

    UPDATE ENROLLMENT SET grade = p_grade;

    DBMS_OUTPUT.PUT_LINE('FULL NAME: ' || v_first || ' ' || v_last);
    DBMS_OUTPUT.PUT_LINE('Birthdate: ' || v_bday);
    DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);

END IF;

COMMIT;

EXCEPTION
WHEN NO_DATA_FOUND THEN
IF v_flag = 0 THEN
DBMS_OUTPUT.PUT_LINE('Student id : ' || p_s_id || ' does not exist my friend abdul!');
ELSIF v_flag = 1 THEN
DBMS_OUTPUT.PUT_LINE('Course_section id : ' || p_c_sec_id || ' does not exist my friend abdul!');
ELSIF v_flag = 2 THEN
DBMS_OUTPUT.PUT_LINE('Combination of the student id : ' || p_s_id || ' and of the course_section id : ' || p_c_sec_id || ' does not exist my friend abdul!');
END IF;
END;
/
show error

----------------- Q1 D

SET SERVEROUTPUT ON
-- The command below will show this : Student id : 999 does not exist my friend abdul!
EXEC pontbriand_p1(999,1,'a');



----------------- Q2 

CREATE OR REPLACE PROCEDURE pontbriand_p2 AS

BEGIN

FOR i IN (SELECT f_id, f_last, f_first, f_rank FROM faculty) LOOP

    DBMS_OUTPUT.PUT_LINE(' F_id : ' || i.f_id);
    DBMS_OUTPUT.PUT_LINE(' F_last : ' || i.f_last);
    DBMS_OUTPUT.PUT_LINE(' F_rank : ' || i.f_rank);
    DBMS_OUTPUT.PUT_LINE('|');


       FOR j IN (   SELECT cs.c_sec_id, l.bldg_code, l.room, c.course_name
                    FROM course_section cs
                    JOIN LOCATION l
                    ON cs.loc_id = l.loc_id
                    JOIN course c
                    ON c.course_id = cs.course_id
                    WHERE cs.f_id = i.f_id

                ) LOOP

                        DBMS_OUTPUT.PUT_LINE('|     C_SEC_ID: ' || j.c_sec_id);
                        DBMS_OUTPUT.PUT_LINE('|     Course name: ' || j.course_name);
                        DBMS_OUTPUT.PUT_LINE('|     Bldg Code: ' || j.bldg_code);
                        DBMS_OUTPUT.PUT_LINE('|     Room: ' || j.room);
                        DBMS_OUTPUT.PUT_LINE('|');
                        
                    
                    END LOOP;
    DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;
    END;
    /
    show error
    SET SERVEROUTPUT ON
    EXEC pontbriand_p2;


----------------- Q3

CREATE OR REPLACE PROCEDURE pontbriand_p3 AS

v_age NUMBER;

BEGIN


FOR i IN (SELECT s_id, s_last, s_first, s_dob FROM student) LOOP

v_age := pontbriand_f1(i.s_dob);

DBMS_OUTPUT.PUT_LINE('Student ID: ' || i.s_id);
DBMS_OUTPUT.PUT_LINE('Student Last Name: ' || i.s_last);
DBMS_OUTPUT.PUT_LINE('Student First Name: ' || i.s_first);
DBMS_OUTPUT.PUT_LINE('Student Date of birth: ' || i.s_dob);
DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);
DBMS_OUTPUT.PUT_LINE('|');
END LOOP;
END;
/
show error
SET SERVEROUTPUT ON
EXEC pontbriand_p3;
