----------Q1

CONNECT des02/des02;

CREATE OR REPLACE PACKAGE pack_project9 IS
PROCEDURE customer_insert(p_c_last VARCHAR2, p_c_birthdate DATE);
PROCEDURE customer_insert(p_c_last VARCHAR2, p_c_address VARCHAR2);
PROCEDURE customer_insert(p_c_last VARCHAR2, p_c_first VARCHAR2, p_c_address VARCHAR2);
PROCEDURE customer_insert(p_c_id NUMBER, p_c_last VARCHAR2, p_c_birthdate DATE);
FUNCTION getMaxCustomerId RETURN NUMBER;

END;
/

CREATE OR REPLACE PACKAGE BODY pack_project9 IS

FUNCTION getMaxCustomerId RETURN NUMBER AS
v_max NUMBER;
BEGIN
    SELECT MAX(c_id + 1) INTO v_max FROM CUSTOMER;
RETURN v_max;
END;

PROCEDURE customer_insert(p_c_last VARCHAR2, p_c_birthdate DATE) AS
    BEGIN
    INSERT INTO customer(c_id, c_last, c_birthdate)
            VALUES (getMaxCustomerId, p_c_last, p_c_birthdate);
    COMMIT;
    END;

PROCEDURE customer_insert (p_c_last VARCHAR2, p_c_address VARCHAR2) AS
    BEGIN
    INSERT INTO customer(c_id, c_last, c_address)
        VALUES(getMaxCustomerId, p_c_last, p_c_address);
    COMMIT;
    END;

PROCEDURE customer_insert (p_c_last VARCHAR2, p_c_first VARCHAR2, p_c_address VARCHAR2) AS
    BEGIN
    INSERT INTO customer(c_id, c_last, c_first, c_address)
        VALUES(getMaxCustomerId, p_c_last, p_c_first, p_c_address);
    COMMIT;
    END;
PROCEDURE customer_insert (p_c_id NUMBER, p_c_last VARCHAR2, p_c_birthdate DATE) AS
    BEGIN
    INSERT INTO customer(c_id, c_last, c_birthdate)
        VALUES(p_c_id, p_c_last, p_c_birthdate);
    COMMIT;
    END;
END;
/
SET SERVEROUTPUT ON
SET LINESIZE 200
--TEST 1
EXEC pack_project9.customer_insert('Pontbriand', TO_DATE('1984-07-01'));

--TEST 2
EXEC pack_project9.customer_insert('Cornelius', '1234 Lasalle Street');

--TEST 3
EXEC pack_project9.customer_insert('Tremblay', 'Julien', '4321 College Street');

--TEST 4
EXEC pack_project9.customer_insert(999, 'Abdul', TO_DATE('1991-01-04'));

SELECT c_id, c_last, c_first, c_address, c_birthdate FROM customer;

-------------Q2

CONNECT des03/des03;

CREATE OR REPLACE PACKAGE pack_project9Q2 IS

global_last_student_id NUMBER;
FUNCTION getLastStudentId RETURN NUMBER;

PROCEDURE student_insert(p_s_id NUMBER, p_s_last VARCHAR, p_s_dob DATE);
PROCEDURE student_insert(p_s_last VARCHAR, p_s_dob DATE);
PROCEDURE student_insert(p_s_last VARCHAR, p_s_address VARCHAR2);
PROCEDURE student_insert(p_s_last VARCHAR, p_s_first VARCHAR, p_s_dob DATE, p_f_id NUMBER);

END;
/

CREATE OR REPLACE PACKAGE BODY pack_project9Q2 IS

    FUNCTION getLastStudentId RETURN NUMBER AS
        v_max NUMBER;
        BEGIN
            SELECT MAX(s_id + 1) INTO v_max FROM student;
        RETURN v_max;
    END;

    PROCEDURE student_insert(p_s_id NUMBER, p_s_last VARCHAR, p_s_dob DATE) AS
        ex_futureDob EXCEPTION;
        BEGIN

        IF p_s_dob > sysdate THEN
        RAISE ex_futureDob;
        END IF;

        INSERT INTO student(s_id, s_last, s_dob)
            VALUES(p_s_id, p_s_last, TO_DATE(p_s_dob));
        COMMIT;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN 
        DBMS_OUTPUT.PUT_LINE('Error - Student ID already exists my friend ABDUL!');
        WHEN ex_futureDob THEN
        DBMS_OUTPUT.PUT_LINE('Error - Birthdate is in the future!');
    END;

    PROCEDURE student_insert(p_s_last VARCHAR, p_s_dob DATE) AS
        ex_futureDob EXCEPTION;
        BEGIN

        IF p_s_dob > sysdate THEN
        RAISE ex_futureDob;
        END IF;

        INSERT INTO student(s_id, s_last, s_dob)
            VALUES(getLastStudentId, p_s_last, TO_DATE(p_s_dob));
        COMMIT;

        EXCEPTION
        WHEN ex_futureDob THEN
        DBMS_OUTPUT.PUT_LINE('Error - Birthdate is in the future!');
        WHEN DUP_VAL_ON_INDEX THEN 
        DBMS_OUTPUT.PUT_LINE('Error - Student ID already exists my friend ABDUL!');
    END;

    PROCEDURE student_insert(p_s_last VARCHAR, p_s_address VARCHAR2) AS
        BEGIN
        INSERT INTO student(s_id, s_last, s_address)
            VALUES(getLastStudentId, p_s_last, p_s_address);
        COMMIT;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN 
        DBMS_OUTPUT.PUT_LINE('Error - Student ID already exists my friend ABDUL!');
    END;

    PROCEDURE student_insert(p_s_last VARCHAR, p_s_first VARCHAR, p_s_dob DATE, p_f_id NUMBER) AS
        v_f_id NUMBER;
        ex_futureDob EXCEPTION;
        BEGIN

        SELECT f_id INTO v_f_id FROM student WHERE f_id = p_f_id;

        IF p_s_dob > sysdate THEN
        RAISE ex_futureDob;
        END IF;

        INSERT INTO student(s_id, s_last, s_first, s_dob, f_id)
            VALUES(getLastStudentId, p_s_last, p_s_first, TO_DATE(p_s_dob), p_f_id);
        COMMIT;

        EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN 
        DBMS_OUTPUT.PUT_LINE('Error - Student ID already exists my friend ABDUL!');
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error - Factuly ID does not exist');
        WHEN ex_futureDob THEN
        DBMS_OUTPUT.PUT_LINE('Error - Birthdate is in the future!');
    END;

END;
/

SET SERVEROUTPUT ON
SET LINESIZE 200

--TEST 1
EXEC pack_project9Q2.student_insert(1, 'Montebello', TO_DATE('1984-07-01'));

--TEST 2
EXEC pack_project9Q2.student_insert('Cornelius', TO_DATE('2055-02-01'));

--TEST 3
EXEC pack_project9Q2.student_insert('Tremblay', '4321 College Street');

--TEST 4
EXEC pack_project9Q2.student_insert('Abdul', 'Ulyss', TO_DATE('1991-01-04'), 999);

SELECT s_id, s_last, s_first, s_address, s_dob, f_id FROM student;

