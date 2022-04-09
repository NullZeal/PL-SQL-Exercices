Menu du jour
Review on packages

Redistribute part 8 
Lecture on OVERLOADING PROCEDURE / FUNCTION

Part 9
Lecture on DATABASE TRIGGER
Part10

--------------------------

Overloading procedure
Many procedures with the same name_of_cursor

Sometimes you have either

-empno, ename, job
-ename, job,
-ename, sal

Create an overloading procedure to insert a new employee. If the employee number is not provided by the user, use a number from a sequence named emp_sequence that start with number 7935

sol :

CREATE OR REPLACE SEQUENCE emp_sequence START WITH 7935;

CREATE OR REPLACE PACKAGE April4 IS
PROCEDURE employee_insert(p_empno NUMBER, p_ename VARCHAR2, p_job VARCHAR2);
PROCEDURE employee_insert(p_ename VARCHAR2, p_job VARCHAR2);
PROCEDURE employee_insert(p_ename VARCHAR2, p_sal NUMBER);
END;
/


CREATE OR REPLACE PACKAGE BODY April4 IS

PROCEDURE employee_insert(p_empno NUMBER, p_ename VARCHAR2, p_job VARCHAR2) AS
    BEGIN
    INSERT INTO emp(empno, ename, job)
            VALUES (p_empno, p_ename, p_job);
    END;

PROCEDURE employee_insert (p_ename VARCHAR2, p_job VARCHAR2) AS
    BEGIN
    INSERT INTO emp(empno, ename, j_job)
        VALUES(emp_sequence.NEXTVAL, p_ename, p_job);
    END;

PROCEDURE employee_insert (p_ename VARCHAR2, p_sal NUMBER) AS
    BEGIN
    INSERT INTO emp(empno, ename, sal)
        VALUES(emp_sequence.NEXTVAL, p_ename, p_sal);
    END;
END;
/

EXEC April4.employee_insert(1,'Lota','PROGRAMMER');
EXEC April4.employee_insert('Abdul','Programmer');
EXEC April4.employee_insert('Neetu',4999');

RESTRICTION 
Cannot create overload procedure with the same number of parameter of the same Family

Ex  : 

PROCEDURE customer_insert(p_name VARCHAR2, p_job VARCHAR2);
PROCEDURE customer_insert(p_name CHAR, p_address CHAR);

PROCEDURE customer_insert(p_name VARCHAR2, p_custid NUMBER);
PROCEDURE customer_insert(p_name VARCHAR2, p_salary NUMBER);

CANNOT CREATE OVERLOADING FUCTION WHERE THE DIFFERENT IS ONLY IN THE RETURNING DATATYPE

Ex :

FUCTION find_job(p_empno NUMBER,) RETURN VARCHAR2;
FUCTION find_job(p_empno NUMBER,) RETURN BOOLEAN;


-------------------------------------------

Lecture on DATABASE TRIGGERS

[] = optionally

Syntax : CREATE OR REPLACE TRIGGER name_of_trigger
         [BEFORE | AFTER] [INSERT | UPDATE | DELETE] ON name_of_table
         [FOR EACH ROW]
         [WHEN condition];

EXAMPLE : Lota = user that needs to monitor her table enrollment, create sequence, table to audit the table enrollment by saving, when, who modify the table enrollment.

CREATE SEQUENCE enrl_audit_seq;

CREATE TABLE enrl_audit(enrl_audit_id NUMBER, date_updated DATE, updating_user VARCHAR2(20));

CREATE OR REPLACE TRIGGER enrl_audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON enrollment

BEGIN

    INSERT INTO enrl_audit
    VALUES(enrl_audit_seq.NEXTVAL, systade, user);
END;
/

GRANT SELECT, INSERT, UPDATE, DELETE ON enrollment TO neetu;

--neetu

SELECT * FROM lota.enrollment;
UPDATE lota.enrollment SET grade = 'X';
WHERE s_id = 3 AND c_sec_id = 12;

COMMIT;

-- lota

SELECT enrl_audit_id, TO_CHAR(date_updated, 'DD MM YYYY Year Day HH:MI;SS Am'),
updating_user 
FROM enrl_audit;

EX: Modify the table enrl_audit by adding a column named ACTION_PERFORMED to record whether INSERT, UPDATE, or DELETE has been performed by other user to the table enrollment.

Modify the trigger enrl_audit_trigger accordingly.

SOl : 

alter table enrl_audit
ADD (action_performed VARCHAR2(3));

CREATE OR RAPLACE TRIGGER enrl_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON enrollment
BEGIN
IF INSERTING THEN
    INSERT INTO enrl_audit
    VALUES(enrl_audit_seq.NEXTVAL, sysdate, user, 'INSERT');
ELSIF UPDATING THEN
    INSERT INTO enrl_audit
    VALUES(enrl_audit_seq.NEXTVAL, sysdate, user, 'UPDATE');
ELSIF DELETING THEN
    INSERT INTO enrl_audit
    VALUES(enrl_audit_seq.NEXTVAL, sysdate, user, 'MITA DO');
END IF;
END;
/

-- NEETU

SELECT * FROM lota.enrollment;
UPDATE lota.enrollment SET grade = 'A'
WHERE s_id = 6 AND c_sec_id = 12;

INSERT INTO lota.enrollment
VALUES(6,10,'B');

DELETE FROM lota.enrollment
WHERE s_id = 5 AND c_sec_id = 13;


--LOTA


SELECT enrl_audit_id, TO_CHAR(date_updated, 'DD MM YYYY Year Day HH:MI;SS Am'),
updating_user 
FROM enrl_audit;

EX5 : 

Create sequence, trigger, to audit the table enrollment when it is UPDATED, save the old data in a table called enrl_row_audit usingthe design below:

ENRL_ROW_AUDIT (row_number, date_updated, updating_user, old_s_id, old_c_sec_id, old_grade);

sol: 

CREATE SEQUENCE enrol_row_audit_seq;

CREATE TABLE enrl_row_audit(row_number NUMBER, date_updated DATE, updating_user VARCHAR2(30), old_s_id NUMBER, old_c_sec_id NUMBER, old_grade CHAR(1))

CREATE OR REPLACE TRIGGER enrl_row_audit_trigger
AFTER UPDATE ON enrollment
FOR EACH ROW
    BEGIN
        INSERT INTO
            enrl_row_audit
                VALUES(enrl_row_audit_seq.NEXTVAL, sysdate, user, :OLD.s_id, :OLD.c_sec_id, :OLD.grade)
END;
/

testing UPDATE lota.enrollment SET grade = 'x'
WHERE s_id = 6;

lota
SELECT row_number, TO_CHAR(date_updated, 'DD MM YYYY Year Day HH:MI:SS am'),
updating_user, old_s_id, old_c_sec_id, old_grade
FROM enrl_row_audit;

EX6: Modify the trigger of example number 5 to let it fire only if the grade is not null

    
CREATE OR REPLACE TRIGGER enrl_row_audit_trigger
AFTER UPDATE ON enrollment
FOR EACH ROW
WHEN (old.grade IS NOT NULL)
    BEGIN
        INSERT INTO
            enrl_row_audit
                VALUES(enrl_row_audit_seq.NEXTVAL, sysdate, user, :OLD.s_id, :OLD.c_sec_id, :OLD.grade)
END;
/

testing : 

UPDATE lota.enrollment SET grade = 'Z'
WHERE s_id = 3;

UPDATE lota.enrollment SET grade = 'v'
WHERE s_id = 3;





