--Menu du jour
/*
Review cursor
Cursor with parameter
Hint for project part 5 (already did it!)
Project Part 6
*/

--Example: Create a procedure to display all students (use script 7Northwoods)
--(Hint : Yield explicit cursor)

--Sol : 
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE display_all_student AS

CURSOR stud_cur IS 
SELECT s_id, s_last, s_first
       FROM student;

v_s_id student.s_id%TYPE;
v_s_last student.s_last%TYPE;
v_s_first student.s_first%TYPE;

BEGIN
OPEN stud_cur;

FETCH stud_cur INTO v_s_id, v_s_last, v_s_first;

WHILE stud_cur%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('Row Line: ' || stud_cur%ROWCOUNT || ' Student ID: ' || v_s_id || ' First Name: ' || v_s_first || ' Last Name: ' || v_s_last);
    FETCH stud_cur INTO v_s_id, v_s_last, v_s_first;
    END LOOP;
CLOSE stud_cur;
END;
/
show error;
EXEC display_all_student;

--------------------------------------------------------
Cursor with parameter
'Syntax:'

CURSOR name)of)cursor (name_of_parameter DATAYPE) IS
    SELECT column1, column2...
    FROM name_of_table
    WHERE columnX = name of parameter;

/*EXAMPLE 2 : Create a procedure to display all departments. 
Under each department, display all employees who work for the department just displayed.
(Hint: Use 2 cursors! Inner and Outer, recursion. THe inner cursor is a cursor with parameter)*/


-- Solution :

connect scott/tiger;

CREATE OR REPLACE PROCEDURE double_curr_test1 AS

CURSOR dept_cur IS
    SELECT deptno, dname, loc 
        FROM dept;

dept_record dept_cur%ROWTYPE;
        
CURSOR emp_cur(pc_deptno emp.deptno%TYPE) IS
SELECT empno, ename, job
    FROM emp
        WHERE deptno = pc_deptno;

emp_record emp_cur%ROWTYPE;

BEGIN

OPEN dept_cur;

FETCH dept_cur INTO dept_record;

WHILE dept_cur%FOUND LOOP
DBMS_OUTPUT.PUT_LINE('------------------------------');
DBMS_OUTPUT.PUT_LINE('Department #: ' || dept_record.deptno || ' is ' || dept_record.dname || ' located in ' || dept_record.loc);
    OPEN emp_cur(dept_record.deptno);
    FETCH emp_cur INTO emp_record;
    WHILE emp_cur%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('Employee # : '|| emp_record.empno || ' is ' || emp_record.ename || '. He or she is a ' || emp_record.job || 'of department number ' || dept_record.deptno);
        FETCH emp_cur INTO emp_record;
        END LOOP;
        CLOSE emp_cur;
    FETCH dept_cur INTO dept_record;
    END LOOP;
    CLOSE dept_cur;
END;
/
show error;
SET SERVEROUTPUT ON;
EXEC double_curr_test1;



------------------------------------

Syntax:

Cursor name_of_cursor IS
    SELECT column1, column2...
        FROM tableName
            FOR UPDATE OF columnx;

EXAMPLE #3 : Create a procedure named emp_update. It accepts a number representing a percentage increase
            in salary to update and display the old and new salary of all employees.

You must LOCK the data before update. (Hint : Use the cursor for update and the WHERE CURRENT OF to locate the row to be updated)

CREATE OR REPLACE PROCEDURE emp_update (p_percent NUMBER) AS

CURSOR emp_cur IS

SELECT empno, ename, sal 
    FROM emp
        FOR UPDATE OF sal;

v_empno emp.empno%TYPE;
v_ename emp.ename%TYPE;
v_sal emp.sal%TYPE;

v_new_sal NUMBER;

BEGIN

OPEN emp_cur;

FETCH emp_cur INTO v_empno, v_ename, v_sal;

WHILE emp_cur%FOUND LOOP
    v_new_sal := v_sal + v_sal*P_percent/100;
    UPDATE emp SET sal = v_new_sal WHERE CURRENT OF emp_cur;
    DBMS_OUTPUT.PUT_LINE('Employee Number ' || v_empno || ' is ' || v_ename || '. His old salary was ' || v_sal || ' and the new sal is :' || v_new_sal);
    FETCH emp_cur INTO v_empno, v_ename, v_sal;
END LOOP;

COMMIT;

CLOSE emp_cur;

END;
/
show error;
SET SERVEROUTPUT ON;
EXEC emp_update(100);