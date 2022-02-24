-- TO ADD IN TOP 

CONNECT sys/sys as sysdba;
DROP USER julienUser CASCADE;
CREATE USER julienUser IDENTIFIED BY 123;
GRANT CONNECT RESOURCE julienUser;

CONNECT julienUser/123;

CREATE OR REPLACE FUNCTION



SELECT IN PL/SQLCODE
SYNTAX:

SELECT column_name1, column_name2,...
INTO variable1, variable2, ...
FROM name_of_table
[ WHERE condition ]

EX:

-- CREATE A PROCEDURE named show_employee that accepts the employee Number and display his name, his annual salary
-- on the screen as follow:
-- Employee number X is Y. HE earns $Z a year.

--note that the salary of table emp is monthly!

CREATE OR REPLACE PROCEDURE show_employee (p_empno IN NUMBER) AS 

v_ename VARCHAR2(20);
v_sal NUMBER;
v_annual_sal NUMBER;
empno NUMBER;

BEGIN

SELECT ename, sal
	INTO v_ename, v_sal 
		FROM emp
			WHERE empno = p_empno; 
			v_annual_sal := v_sal * 12;

DBMS_OUTPUT.PUT_LINE('Employee Number ' || p_empno || ' is ' || v_ename || '. He earns $'|| v_annual_sal || ' a month.');

EXCEPTION 
--	WHEN TOO_MANY_ROWS THEN
--	DBMS_OUTPUT.PUT_LINE('Your select return many many and many rows my friend ABDUL!');
--	WHEN NO_DATA_FOUND THEN
--	DBMS_OUTPUT.PUT_LINE('Si la planete que vous cherchez ne se trouve pas dans nos archives, elle nexiste pas!');
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('Whoops. Something wrong appeared. We are so sorry.');
END;
/
exec show_employee (1);


-- EXAMPLE #2

-- CREATE a procedure named up_or_in_emp, that accepts employee number, name and salary of an employee
-- THe procedure will update the employee if he/she is existed, otherwise
-- the new employee will be inserted

CREATE OR REPLACE PROCEDURE up_or_in_emp (p_empno IN NUMBER, p_empname VARCHAR2, p_salary NUMBER) AS
v_ename VARCHAR2(20);
v_salary NUMBER;
BEGIN
	v_salary := p_salary * 12;
	SELECT ename, sal
		INTO v_ename, v_salary
			FROM emp
				WHERE empno = p_empno;
								
				-- if found, can CONTINUE
				DBMS_OUTPUT.PUT_LINE('Employee Found. Updating.');
				UPDATE emp SET ename = p_empname, sal = p_salary WHERE empno = p_empno;
				
EXCEPTION
	WHEN NO_DATA_FOUND THEN 
	DBMS_OUTPUT.PUT_LINE('Employee not Found. Inserting employee.');
	INSERT INTO emp(empno, ename, sal) VALUES (p_empno, p_empname, v_salary);
				
END;
/				
exec up_or_in_emp(16, 'aaaasd2d2ddaaa', 1000);






Q3
SELECT to_date('12-12-2000','DD-MM-YYYY') - SYSDATE FROM dual;
date - date = n days / 365 = years
display only INTEGER

Q4

Nothing to update if no values change

Display the correct error

''The skill ID does not exist''