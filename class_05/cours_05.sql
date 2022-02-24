-- Parameter MODE
	-- IN
	-- OUT
	-- IN OUT

-- 1 MODE IN
	-- This is the default mode, keyword IN is not mandatory!
	-- CREATE OR REPLACE PROCEDURE example1(parameter_name IN datatype) AS
	-- CREATE OR REPLACE PROCEDURE example1(parameter_name datatype) AS
	-- Parameter can be READ ONLY
	
	-- Appear on the RIGHT SIDE of the assigning OPERATOR
	-- Variable := parameter_name
	--PAss by value -- exec example(500)
	
-- 2 MODE OUT
	-- The keyword OUT is mandatory!
	-- CREATE OR REPLACE PROCEDURE example2(parameter_name OUT datatype) AS
	-- Parameter can be WRITE ONLY
	
	-- Appear on the LEFT SIDE of the assigning OPERATOR
	-- parameter_name := Variable;
	-- PAss by variable -- exec example(v_sal)
	
-- 3 MODE IN OUT
	-- The keyword IN OUT is mandatory!
	-- CREATE OR REPLACE PROCEDURE example3(parameter_name IN OUT datatype) AS
	-- Parameter can be BOTH read or WRITE 
	
	-- Appear on the RIGHT SIDE of the assigning OPERATOR for reading
		--  variable := parameter_name;
	-- Appear on the left side of the assignment OPERATOR for Writing
		-- parameter_name := Variable;

	-- PAss by variable -- exec example(v_sal)
	
	
	
	
	
	
-- example #1: Create a procedure that accepts an employee number to return his salary and name to the calling environment

CREATE OR REPLACE PROCEDURE p_find_emp(p_empno_in IN NUMBER, p_ename_out OUT VARCHAR2, p_sal_out OUT NUMBER) AS
-- make sure if someone modify it, i dont have to modify

v_ename emp.ename%TYPE; 
v_sal emp.sal%TYPE;

BEGIN

SELECT ename, sal 
	INTO v_ename, v_sal
		FROM emp
			WHERE empno = p_empno_in;
			
p_ename_out := v_ename;
p_sal_out := v_sal;

EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Employee Number ' || p_empno_in || ' does not exist my friend Abdul!');
END;
/


-- EX #2
-- Create a procedure, name it p_show_emp that accepts an emp number and yse the procedure of ex1 to display the following :
-- EMPLOYEE number X is : Y. He earns Z dollars a month!
-- WHERE x is the employee number inserted by the user. Y and Z are the calue returned by the procedure

CREATE OR REPLACE PROCEDURE p_show_emp(p_empno emp.empno%TYPE) AS
v_ename emp.ename%TYPE; 
v_sal emp.sal%TYPE;
BEGIN
p_find_emp(p_empno, v_ename, v_sal);
IF v_ename IS NOT NULL THEN
DBMS_OUTPUT.PUT_LINE('Employee Number ' || p_empno || ' is : ' || v_ename || ' and he ears $ ' || v_sal || ' a month!');
END IF;
END;
/


-- EX 3

--Create a procedure htat accepts a parameter of mode IN OUT of NUMBER type (emopno) and 
-- another parameter of datatype VARCHAR2 of mode IN OUT.

-- The procedure will accept the employee number and the job of an employee.
-- IT will return the salary, name, and update the job of the employee inserted.


CREATE OR REPLACE PROCEDURE p_update_emp (p_empno_sal IN OUT NUMBER, p_job_ename IN OUT VARCHAR2) AS
v_ename emp.ename%TYPE; 
v_sal emp.sal%TYPE;
BEGIN
SELECT ename, sal
	INTO v_ename, v_sal
		FROM emp
			WHERE empno = p_empno_sal;
			
UPDATE emp SET job = p_job_ename WHERE empno = p_empno_sal;

p_empno_sal := v_sal;
p_job_ename := v_ename;

EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Employee Number ' || p_empno_sal || ' does not exist my friend Abdul!');
END;
/

-- EX #4
-- Create a procedure, name it p_UP_show_emp that accepts an emp number and yse the procedure of ex1 to display the following :

-- EMPLOYEE number X is : Y. He is a M and earns Z dollars a month!

-- WHERE x is the employee number inserted by the user, M is the JOB inserted by the user, Y and Z are the calue returned by the procedure


CREATE OR REPLACE PROCEDURE p_UP_show_emp(p_empno NUMBER, p_job VARCHAR2) AS
v_empno_sal NUMBER := p_empno;
v_job_name VARCHAR2(50) := p_job;
BEGIN
p_update_emp(v_empno_sal, v_job_name);

IF v_empno_sal <> p_empno THEN
DBMS_OUTPUT.PUT_LINE('Employee Number ' || p_empno || ' is : ' || v_job_name || '. He is a ' ||  p_job || ' and he ears $ ' || v_empno_sal || ' a month!');
END IF;
END;
/

SELECT empno, ename, sal, comm, NVL(comm,0), sal * 12 + nvl(comm,0)"Annual Salary" FROM emp;

