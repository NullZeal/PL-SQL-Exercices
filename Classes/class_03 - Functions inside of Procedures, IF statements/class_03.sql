-- Cours3

-- SELECT to_char

-- Functions in a PROCEDURE

-- include date : 

-- SELECT to_char(SYSDATE, 'DD Month YYYY Year Day HH:MI:SS AM') FROM dual;
-- 
-- show user
-- how are you doing;
-- 
-- SPOOL OFF;
-- 
-- DROP USER neetu CASCADE;
-- START c:\db2\

Example 1 : Create a function that accepts a number to return 5 times the value inserted


SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION f_fiveTime (p_in in NUMBER) RETURN NUMBER AS
	v_result NUMBER;
BEGIN
	v_result := p_in * 5;
RETURN v_result;
END;
/

-- TO TEST :

SELECT f_fivetime(12323213) FROM dual;

Other way :


Example 2 : Create a procedure named use_ex1 that accpets a 
number and use the function of example 1 to display EXACTLY 
the following: FIVE TIME NUMBER X IS Y!

where x is the number inserted and y is the result returned from the function f_fivetime

solution : (HINT : 20% is on paper, NO NEED FOR REPLACE)

CREATE OR REPLACE PROCEDURE use_ex1 (p_in IN NUMBER) AS 
v_result NUMBER;
BEGIN
v_result := f_fivetime(p_in);
DBMS_OUTPUT.PUT_LINE('FIVE time number ' || p_in || ' is ' || v_result ||'!');
END;
/

exec use_ex1(5);

-- IF STATEMENT

Syntax : 
IF condition1 THEN 
statement1;
END IF;

statement will be executed when the condition1 is evaluted to TRUE

IF condition1 THEN 
statement1;
ELSE
statement2;
END IF;

statement1 will be executed when the condition is evaluated to true, otherwise
statement2 will be executed(when condition1 is evaluated to FASLE)


NESTED IF

IF condition1 THEN
statement1
ELSE
	IF condition2 THEN
		statement2
	END IF
END IF

EACH IF MUST HAVE an END IF;
statement1 will be executed when the co


CREATE OR REPLACE PROCEDURE find_grade (P_IN in number) AS
	v_grade VARCHAR2(100);
BEGIN
 IF p_in > 100 OR p_in <0 THEN
	v_grade := 'X';
 ELSIF p_in >= 90 THEN 
	v_grade := 'A';
 ELSIF p_in >= 80 THEN
	v_grade := 'B';
 ELSIF p_in >= 70 THEN
	v_grade := 'C';
 ELSIF p_in >= 60 THEN
	v_grade := 'D';
 ELSIF p_in <60 THEN
	v_grade:='R';
 END IF;
 
 
 IF v_grade ='X' THEN
	DBMS_OUTPUT.PUT_LINE('Please insert number from 0 to 100!');
 ELSIF v_grade = 'A' THEN
	DBMS_OUTPUT.PUT_LINE(' For a mark of ' || p_in||', You have an ' || v_grade);
ELSIF v_grade = 'R' THEN
DBMS_OUTPUT.PUT_LINE('ENROLL IN THIS DATABASE CLASS AGAIN');
 ELSE
	DBMS_OUTPUT.PUT_LINE('For a mark of ' || p_in||', You have a ' || v_grade);
 END IF;
END;
/

exec find_grade(100)
