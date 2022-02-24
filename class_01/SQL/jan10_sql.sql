CREATE OR REPLACE PROCEDURE Bonus1 (age1 IN NUMBER, age2 IN NUMBER, age3 IN NUMBER) AS
	v_total_age NUMBER;
		BEGIN
			v_total_age := age1 + age2 + age3;
				DBMS_OUTPUT.PUT_LINE('We are Masoud, Jessy and Julien and our combined age is ' || v_total_age);
					END;
						/
EXEC Bonus1(30,31,32);