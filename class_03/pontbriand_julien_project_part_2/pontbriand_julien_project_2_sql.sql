CONNECT sys/sys as sysdba;
DROP USER julienUser CASCADE;
CREATE USER julienUser IDENTIFIED BY 123;
GRANT CONNECT, RESOURCE TO julienUser;
CONNECT julienUser/123;
SET SERVEROUTPUT ON

--Q1
CREATE OR REPLACE FUNCTION productCalculator(p_num1_in IN NUMBER, p_num2_in IN NUMBER) RETURN NUMBER AS
v_result NUMBER;
BEGIN
v_result := p_num1_in * p_num2_in;
RETURN v_result;
END;
/
SELECT productCalculator(10,10) FROM dual;


--Q2
CREATE OR REPLACE PROCEDURE areaCalculator (p_width_in IN NUMBER, p_height_in IN NUMBER) AS
v_result NUMBER;
BEGIN
v_result := productCalculator(p_width_in, p_height_in);
	DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || p_width_in || ' by ' || p_height_in || ' the area is ' || v_result);
END;
/
exec areaCalculator(10,10);


--Q3
CREATE OR REPLACE PROCEDURE areaCalculator2 (p_width_in IN NUMBER, p_height_in IN NUMBER) AS
v_result NUMBER;
BEGIN
v_result := productCalculator(p_width_in, p_height_in);
IF p_width_in = p_height_in THEN
	DBMS_OUTPUT.PUT_LINE('For a square of size ' || p_width_in || ' by ' || p_height_in || ' the area is ' || v_result);
ELSE 
	DBMS_OUTPUT.PUT_LINE('For a rectangle of size ' || p_width_in || ' by ' || p_height_in || ' the area is ' || v_result);
END IF;
END;
/
exec areaCalculator2(10,10);

			
-- Q4
CREATE OR REPLACE PROCEDURE convertMoney(p_cadAmount_in IN NUMBER, p_newCurrencyLetter_in IN VARCHAR2) AS
v_convertedAmount NUMBER;
v_convertedCurrencyName VARCHAR2(50);

BEGIN

IF p_newCurrencyLetter_in = 'E' THEN
v_convertedAmount := p_cadAmount_in * 1.5;
v_convertedCurrencyName := 'EURO';

ELSIF p_newCurrencyLetter_in = 'Y' THEN
v_convertedAmount := p_cadAmount_in * 100;
v_convertedCurrencyName := 'YEN';

ELSIF p_newCurrencyLetter_in = 'V' THEN
v_convertedAmount := p_cadAmount_in * 10000;
v_convertedCurrencyName := 'Viet Nam DONG';

ELSIF p_newCurrencyLetter_in = 'Z' THEN
v_convertedAmount := p_cadAmount_in * 1000000;
v_convertedCurrencyName := 'Endora ZIP';
END IF;

DBMS_OUTPUT.PUT_LINE('FOR ' || p_cadAmount_in || ' dollars Canadian, you will have ' || v_convertedAmount || ' ' || v_convertedCurrencyName);
END;
/
EXEC convertMoney(100,'E');


-- QUESTION 5
CREATE OR REPLACE FUNCTION YES_EVEN(p_number_in IN NUMBER) RETURN BOOLEAN AS
BEGIN
IF MOD(p_number_in, 2) = 0 THEN
RETURN TRUE;
ELSE
RETURN FALSE;
END IF;
END;
/

-- QUESTION 5 REVISITED
CREATE OR REPLACE FUNCTION YES_EVEN2(p_number_in NUMBER) RETURN BOOLEAN AS
v_result_boolean := FALSE;
BEGIN
IF MOD(p_number_in, 2) = 0 THEN
v_result_boolean := TRUE;
END IF;
RETURN v_result_boolean;
END;
/



-- QUESTION 6 
CREATE OR REPLACE PROCEDURE isEvenOrOdd (p_number_in IN NUMBER) AS
BEGIN
IF YES_EVEN2(p_number_in) = TRUE THEN
DBMS_OUTPUT.PUT_LINE('NUMBER '|| p_number_in || ' is EVEN');
ELSE
DBMS_OUTPUT.PUT_LINE('NUMBER '|| p_number_in || ' is ODD');
END IF;
END;
/
EXEC isEvenOrOdd(1111);
EXEC isEvenOrOdd(100);


-- QUESTION BONUS
CREATE OR REPLACE PROCEDURE convertMoneyAnyWay(p_initialCurrencyAmount_in IN NUMBER, p_initialCurrencyLetter_in IN VARCHAR2, p_newCurrencyLetter_in IN VARCHAR2) AS

v_initialCurrencyAmountInCAD NUMBER;
v_initialCurrencyName VARCHAR2(50);

v_convertedAmount NUMBER;
v_newCurrencyName VARCHAR2(50);

BEGIN

IF p_initialCurrencyLetter_in = 'C' THEN
	
	v_initialCurrencyAmountInCAD := p_initialCurrencyAmount_in;
	v_initialCurrencyName := 'CAD Dollar';
	
	IF p_newCurrencyLetter_in = 'E' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 1.5;
	v_newCurrencyName := 'EURO';
	
	ELSIF p_newCurrencyLetter_in = 'Y' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 100;
	v_newCurrencyName := 'YEN';
	
	ELSIF p_newCurrencyLetter_in = 'V' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 10000;
	v_newCurrencyName := 'Viet Nam DONG';
	
	ELSIF p_newCurrencyLetter_in = 'Z' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 1000000;
	v_newCurrencyName := 'Endora ZIP';
	END IF;

ELSIF p_initialCurrencyLetter_in = 'E' THEN

	v_initialCurrencyAmountInCAD := p_initialCurrencyAmount_in / 1.5;
	v_initialCurrencyName := 'EURO';
	
	IF p_newCurrencyLetter_in = 'C' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD;
	v_newCurrencyName := 'dollars Canadian';
	
	ELSIF p_newCurrencyLetter_in = 'Y' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 100;
	v_newCurrencyName := 'YEN';
	
	ELSIF p_newCurrencyLetter_in = 'V' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 10000;
	v_newCurrencyName := 'Viet Nam DONG';
	
	ELSIF p_newCurrencyLetter_in = 'Z' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 1000000;
	v_newCurrencyName := 'Endora ZIP';
	END IF;
	
ELSIF p_initialCurrencyLetter_in = 'Y' THEN

	v_initialCurrencyAmountInCAD := p_initialCurrencyAmount_in / 100;
	v_initialCurrencyName := 'YEN';
	
	IF p_newCurrencyLetter_in = 'C' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD;
	v_newCurrencyName := 'dollars Canadian';
	
	ELSIF p_newCurrencyLetter_in = 'E' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 1.5;
	v_newCurrencyName := 'EURO';
	
	ELSIF p_newCurrencyLetter_in = 'V' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 10000;
	v_newCurrencyName := 'Viet Nam DONG';
	
	ELSIF p_newCurrencyLetter_in = 'Z' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 1000000;
	v_newCurrencyName := 'Endora ZIP';
	END IF;	

ELSIF p_initialCurrencyLetter_in = 'V' THEN

	v_initialCurrencyAmountInCAD := p_initialCurrencyAmount_in / 10000;
	v_initialCurrencyName := 'Viet Nam DONG';
	
	IF p_newCurrencyLetter_in = 'C' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD;
	v_newCurrencyName := 'dollars Canadian';
	
	ELSIF p_newCurrencyLetter_in = 'E' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 1.5;
	v_newCurrencyName := 'EURO';
	
	ELSIF p_newCurrencyLetter_in = 'Y' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 100;
	v_newCurrencyName := 'YEN';
	
	ELSIF p_newCurrencyLetter_in = 'Z' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 1000000;
	v_newCurrencyName := 'Endora ZIP';
	END IF;	
	
ELSIF p_initialCurrencyLetter_in = 'Z' THEN

	v_initialCurrencyAmountInCAD := p_initialCurrencyAmount_in / 1000000;
	v_initialCurrencyName := 'Endora ZIP';
	
	IF p_newCurrencyLetter_in = 'C' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD;
	v_newCurrencyName := 'dollars Canadian';
	
	ELSIF p_newCurrencyLetter_in = 'E' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 1.5;
	v_newCurrencyName := 'EURO';
	
	ELSIF p_newCurrencyLetter_in = 'Y' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 100;
	v_newCurrencyName := 'YEN';
	
	ELSIF p_newCurrencyLetter_in = 'V' THEN
	v_convertedAmount := v_initialCurrencyAmountInCAD * 10000;
	v_newCurrencyName := 'Viet Nam DONG';
	END IF;	
END IF;
	
DBMS_OUTPUT.PUT_LINE('FOR ' || p_initialCurrencyAmount_in || ' ' || v_initialCurrencyName || ', you will have ' || v_convertedAmount || ' ' || v_newCurrencyName);
END;
/

EXEC convertMoneyAnyWay(100,'E', 'Z');
EXEC convertMoneyAnyWay(100,'Z', 'V');
EXEC convertMoneyAnyWay(100,'V', 'Z');
EXEC convertMoneyAnyWay(100,'Y', 'E');