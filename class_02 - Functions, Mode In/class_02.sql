-- FUNCTIONS

-- Mode = IN , OUT

CREATE OR REPLACE FUNCTION name_of_function [(parameter_name MODE DATATYPE, ...)] RETURN datatype AS
	BEGIN
		execute statement;
	RETURN name_of_variable;
	END;
	/
	
-- PROCEDURE VS 

-- The procedure can return something complex

-- The function can accept parameters and have to return ONLY 1 value

EX 1 : Create a function called f_triple that accepts a number to return 3 times the value inserted


CREATE OR REPLACE FUNCTION f_triple (p_number_to_be_tripled IN NUMBER) RETURN NUMBER AS
	v_tripled_value NUMBER;
	BEGIN
		v_tripled_value := p_number_to_be_tripled * 3;
		RETURN v_tripled_value;
			END;
				/

To run a function in SQL*Plus do : SELECT name_of_function (value) FROM dual;

ex :  SELECT f_triple(5) FROM dual;

ex : select ename, sal, f_triple(sal) dreamsalary From emp;


