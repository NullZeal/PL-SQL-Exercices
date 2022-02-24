-- PROCEDURE

Use SQL*Plus

PL/SQL is a block language

A block and be inside another block
		
Syntax : 

BEGIN

executable statement ; (have a semicolon)

END; 

/

EX1 : Create an anonymous block that does nothing and then run the block in sql*plus

SOL: 

BEGIN
	NULL;
	   END;
			/

connect sys/sys as sysdba;

CREATE USER admin IDENTIFIED BY admin;

GRANT connect, resource TO admin;

How to save a block?

Create a **function** or a **procedure**.

Block with name can be saved in the database.

--PROCEDURE--

A block with a name and can be saved in the database.

Syntax of a procedure: CREATE OR REPLACE name\_of\_procedure \[(parameter_name MODE datatype, ...)\] AS 

    BEGIN
    	executable statement;
			END;
				/

Ex2  :

Create a procedure named prod_ex1 that does nothing

CREATE OR REPLACE prod_ex1 AS
		BEGIN
			null;
				END;
					/
					
select object_name, object_type FROM user_objects
SELECT text FROM user_source;
a
To run or execute a procedure do:
	EXECUTE procedure_name OR EXEC procedure_name
	
EX3 : Create a procedure named prod_ex3 that has a variable of datatype number, assign number 4 to the variable just declared and print out the content of the variable on the screen (hint : use assigning operator := , and the function PUT_LINE of the build-in package DBMS_OUTPUT to display the value on the screen)

Sol : 

CREATE OR REPLACE PROCEDURE prod_ex3 AS
				-- declaration section (this is a comment), box to declare (optional)
		v_variable1 NUMBER;
	BEGIN
				-- executable section (mandatory)
				-- assign a value to the variable
		v_variable1 := 4;
				--display the content of the variable on the screen
			DBMS_OUTPUT.PUT_LINE(v_variable1);
				END;
					/
					
--To TEST it :
EXEC prod_ex3
show error

To turn on the DBMS_OUTPUT package do:
SET SERVEROUTPUT ON
		
		
-- EXAMPLE 4 : Create a procedure called prod_ex4 that accept a number and display 7 time the value as follow :
-- Seven time the number X is Y 
-- where X is the number inserted, and Y is the result.
--Hint : put the character in the single quotation '', joining the text and number using the concatenation operator ||

-- SOLUTION

CREATE OR REPLACE PROCEDURE prod_ex4 ( p_num_in IN NUMBER) AS
	v_num NUMBER;
		v_result NUMBER;
			BEGIN
				-- assign parameter value to the variable
				v_num := p_num_in;
					-- calculation
					v_result := v_num * 99999;
						DBMS_OUTPUT.PUT_LINE('99999 times the number ' || v_num || ' is ' || v_result);
							END;
								/
--SPOOL CREATION

				
-- SPOOL C:\DB2\jan10_spool.txt creates
-- SPOOL D:\Lasalle\Session 2\Database_II\jan10_spool.txt
-- I love PL/SQL!!!!!
		SPOOL E:\School\AEC Programmation\Lasalle\Session 2\Database 2
		SPOOL E:\School\AEC Programmation\Lasalle\Session 2\Database 2\jan10_spool.txt
		
-- STEP 1 : Create a folder manually
-- STEP 2 Create a spool file in SQL*PLUS

-- SQL > SPOOL C:\BD2\jan10_spool.txt

-- STEP 3 Do your work -- create proceddure, execute...
-- STEP 4 save the spool FILE
-- SQL > SPOOL OFF

-- Bonus 1: Create a procedure named Bonus1 that accepts all your ages (3 numbers) and display all your names and the total of your ages on the screen as follow: 
-- We are x, y, z. We are M years old.
--where X,Y,Z are your name, and M is the total of your age.
-- hint : separate the parameters with a coma)
-- exec Bonus1
-- We are --

CREATE OR REPLACE PROCEDURE Bonus1 (age1 IN NUMBER, age2 IN NUMBER, age3 IN NUMBER) AS
	v_total_age NUMBER;
		BEGIN
			v_total_age := age1 + age2 + age3;
				DBMS_OUTPUT.PUT_LINE('We are Masoud, Jessy and Julien and our combined age is ' || v_total_age);
					END;
						/
EXEC Bonus1(30,31,32);