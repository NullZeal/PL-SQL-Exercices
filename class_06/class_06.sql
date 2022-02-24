/*Menu du jour
-- Loop

1 Basic Loop
2 While Loop
3 For Loop

EXPLICIT CURSOR

BREAK

PROJECT PART 5
*/

1) Basic Loop 

Syntax :

LOOP
	Statement;
EXIT WHEN condition;

LOOP will be terminated when the condition is evaluated to TRUE

Example #1 

Create a procedure, call it p_ex1 to display number 0 to 10 on the screen using BASIC LOOP

CREATE OR REPLACE PROCEDURE p_ex1 AS

v_counter NUMBER := 0;

BEGIN
	LOOP
		DBMS_OUTPUT.PUT_LINE(v_counter);
		v_counter := v_counter + 1;
	EXIT WHEN v_counter > 10;
	END LOOP;
END;
/


2) While Loop

SYNTAX :

WHILE condition LOOP
	Statemennt;
	END LOOP;
	
LOOP will stop when the condition is FALSE

Example #2 

Create a procedure called p_ex2 to display number 0 to 10 on the screen using WHILE LOOP

CREATE OR REPLACE PROCEDURE p_ex2 AS

v_counter NUMBER := 0;

BEGIN

WHILE v_counter >= 10 LOOP
	DBMS_OUTPUT.PUT_LINE(v_counter);
	v_counter := v_counter + 1;
	END LOOP;
END;
/






3) FOR LOOP

SYNTAX:

FOR index IN low_end .. high_end LOOP
	statement;
	END LOOP;
	
index does not have to be declared and it will be incremented automatically


Create a procedure called p_ex3 to display number 0 to 10 on the screen using FOR LOOP


CREATE OR REPLACE PROCEDURE p_ex3 AS

BEGIN

	FOR i IN 0..10 LOOP
	DBMS_OUTPUT.PUT_LINE(i);
	END LOOP;
	END;
	/
	
exec p_ex3




4) Example 4 : 

CREATE OR REPLACE PROCEDURE p_ex4 AS

BEGIN

	FOR i IN REVERSE 0..10 LOOP
	DBMS_OUTPUT.PUT_LINE(i);
	END LOOP;
	END;
	/
	
exec p_ex4



EXPLICIT CURSOR ( PL SQL , to manipulate many rows of data)

SELECT INTO only 1 data manipulation

WE MUST HAVE 4 STEPS for an Explicit cursor

Step 1 : DECLARATION 
	THis is done in the declaration section
		Syntax : CURSOR nameOfCursor IS 
			select statement;
			
Ex : CURSOR dept_curr IS 
		SELECT deptno, dname, loc
			FROM dept;
					
			
Step 2 : OPEN
	THis is done in the executable section
	
	Syntax : 
		OPEN nameOfCursor;

EX OPEN dept_curr;
	
	THe result of step 2 is :

The SELECT is executed
THe result of the select stateement will be available in the memory section called ACTIVE SET	
The cursor attribute %ISOPEN is set to true

YOU CAN VERIFY IF IT IS OPEN OR NOT WITH AN IF STATEMENT

Step 3 : FETCH

	This is done in the excutable section
		Syntax: 
			FETCH nameOfCursor INTO Variables;
			
EX : 
	FETCH dept_curr INTO v_deptno, v_dname, v_loc;

The result of step 3 is :
IF THERE US DATA in the ACTIVE SET : (SUCCESSFUL FETCH)
	Data of the current row in the ACTIVE SET is transfered to the variable
	Cursor attribute %FOUND = TRUE;
					   %NOTFOUND = FALSE
					   %ROWCOUNT is increased by 1

IF THERE IS NO MORE DATA IN THE ACTIVE SET 
						%FOUND = FALSE
						%NOTFOUND = TRUE
						%ROWCOUNT = Unchanged

STEP 4 : CLOSE
	THis is done in executable section
		SYNTAX :
			CLOSE nameOfCursor;

EX : CLOSE dept_curr;

The result of step 4 is : 
	Memory occupied by ACTIVE SET is RETURNED to the SYSTEM
	Cursor attribute %ISOPEN = FALSE;
	
Example : Create procedure, call it show_dept to display all rows of table dept as Follow :

department number x is y located in the city of z, where x is deptno, y is dname and z is loc

CREATE OR REPLACE PROCEDURE show_dept AS

CURSOR dept_curr IS
	SELECT deptno, dname, loc
		FROM dept;

v_deptno dept.deptno%TYPE;
v_dname dept.dname%TYPE;
v_loc dept.loc%TYPE;

BEGIN

OPEN dept_curr;

FETCH dept_curr INTO v_deptno, v_dname, v_loc;

	WHILE dept_curr%FOUND LOOP
		DBMS_OUTPUT.PUT_LINE('row # '|| dept_curr%ROWCOUNT || 'Department number ' || v_deptno || ' is ' || v_dname || ' and is located in ' || v_loc);
		FETCH dept_curr INTO v_deptno, v_dname, v_loc;
	END LOOP;
	
CLOSE dept_curr;
END;
/

EXEC show_dept;


EXAMPLE 2 : 

CREATE A PROCEDURE named emp that accepts a number representing the percentage increase in salary to update the salary pf the employee if the employee earns less than 3000 a month.
Display employee number, name, old and new salary of the employee (all of them)

CREATE OR REPLACE PROCEDURE emp(p_percent IN NUMBER) AS

CURSOR emp_curr IS 
	SELECT empno, ename, sal
		FROM emp;
v_empno emp.empno%TYPE;
v_ename emp.ename%TYPE;
v_sal emp.sal%TYPE;

v_new_sal NUMBER;

BEGIN

OPEN emp_curr;

FETCH emp_curr INTO v_empno, v_ename, v_sal;
	WHILE emp_curr%FOUND LOOP
		IF v_sal < 3000 THEN
			v_new_sal := v_sal + v_sal * p_percent/100;
			UPDATE emp SET sal = v_new_sal WHERE empno = v_empno;
			DBMS_OUTPUT.PUT_LINE('Employee # ' || v_empno || ' is ' || v_ename || '. His old salary was : ' || v_sal || ' and his new salary is :' || v_new_sal);
		ELSE 
			DBMS_OUTPUT.PUT_LINE('Employee # ' || v_empno || ' is ' || v_ename || '. Your salary is : ' || v_sal || '. You are rich!');




