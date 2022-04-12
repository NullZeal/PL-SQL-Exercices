CONNECT des02/des02;

CREATE OR REPLACE PROCEDURE 

CREATE OR REPLACE SEQUENCE customer_sequence START WITH 7;

CREATE OR REPLACE PACKAGE pack_project9 IS
PROCEDURE customer_insert(c_last VARCHAR2, c_birthdate DATE);
PROCEDURE customer_insert(c_last VARCHAR2, c_address VARCHAR2);
PROCEDURE customer_insert(c_last VARCHAR2, c_first VARCHAR2, c_address VARCHAR2);
PROCEDURE customer_insert(c_id NUMBER, c_last VARCHAR2, c_birthdate DATE);

END;
/

CREATE TABLE customer
(c_id NUMBER(5), 
c_last VARCHAR2(30),
c_first VARCHAR2(30),
c_mi CHAR(1),
c_birthdate DATE,
c_address VARCHAR2(30),
c_city VARCHAR2(30),
c_state CHAR(2),
c_zip VARCHAR2(10),
c_dphone VARCHAR2(10),
c_ephone VARCHAR2(10),
c_userid VARCHAR2(50),
c_password VARCHAR2(15),
CONSTRAINT customer_c_id_pk PRIMARY KEY (c_id));


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