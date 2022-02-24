-- QUESTION 1
connect scott/tiger;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE p4q1 (p_number1 IN NUMBER, p_number2 IN NUMBER, p_string OUT VARCHAR2) AS

BEGIN

IF p_number1 = p_number2 THEN
p_string := 'EQUAL';

ELSE
p_string := 'DIFFERENT';
END IF;
END;
/
show error

CREATE OR REPLACE PROCEDURE L8Q1 (p_side1 IN NUMBER, p_side2 IN NUMBER) AS
v_perimeter NUMBER;
v_area NUMBER;
v_form_name VARCHAR2(20);

BEGIN
v_perimeter := (p_side1 * 2) + (p_side2 *2);
v_area := p_side1 * p_side2;
p4q1(p_side1, p_side2, v_form_name);

IF v_form_name = 'EQUAL' THEN
v_form_name := 'square';
ELSE
v_form_name := 'rectangle';
END IF;

DBMS_OUTPUT.PUT_LINE('The area of a ' || v_form_name || ' of size ' || p_side1 || ' by ' || p_side2 || ' is: ' || v_area || '. Its perimeter is ' || v_perimeter);
END;
/
show error;

EXEC L8Q1(2,2);
EXEC L8Q1(2,3);




-- QUESTION 2
connect scott/tiger;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE pseudo_fun (p_width_in_area_out IN OUT NUMBER, p_height_in_perimeter_out IN OUT NUMBER) AS 

v_area NUMBER;
v_perimeter NUMBER;

BEGIN 

v_area := p_width_in_area_out * p_height_in_perimeter_out;
v_perimeter := p_width_in_area_out * 2 + p_height_in_perimeter_out * 2;

p_width_in_area_out := v_area;
p_height_in_perimeter_out := v_perimeter;

END;
/

CREATE OR REPLACE PROCEDURE L4Q2 (p_width IN NUMBER, p_height IN NUMBER) AS

v_width NUMBER := p_width;
v_height NUMBER := p_height;

v_area NUMBER;
v_perimeter NUMBER;
v_form_name VARCHAR2(20);

BEGIN

IF v_width = v_height THEN
v_form_name := 'square';
ELSE
v_form_name := 'rectangle';
END IF;

pseudo_fun(v_width, v_height);

DBMS_OUTPUT.PUT_LINE('The area of a ' || v_form_name || ' is ' || v_width || '. Its perimeter is: ' || v_height);
END;
/
show error

EXEC l4q2(2,2);
EXEC l4q2(2,3);





-- -- QUESTION 3

CONNECT des02/des02;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE price_updater(p_invid_in_price_out in out number, p_percentincrease_in_qoh_out in out number) as

v_updated_price NUMBER;
v_qoh NUMBER;

BEGIN

UPDATE inventory 
	SET inv_price = inv_price * ((p_percentIncrease_in_qoh_out/100) + 1)
		WHERE inv_id = p_invId_in_price_out;
		
SELECT inv_price
	INTO v_updated_price
		FROM inventory
			WHERE inv_id = p_invid_in_price_out;
		
SELECT inv_qoh
	INTO v_qoh
		FROM inventory
			WHERE inv_id = p_invid_in_price_out;

p_invid_in_price_out := v_updated_price;
p_percentincrease_in_qoh_out := v_qoh;

COMMIT;

END;
/

CREATE OR REPLACE PROCEDURE l4q3 (p_invId IN NUMBER, p_percentIncrease IN NUMBER) AS 

v_invId NUMBER;
v_percentIncrease NUMBER;
v_value NUMBER;

BEGIN

v_invId := p_invId;
v_percentIncrease := p_percentIncrease;

price_updater(v_invId, v_percentIncrease);

v_value := v_invId * v_percentIncrease;

DBMS_OUTPUT.PUT_LINE ('The new value in the inventory is: $CA ' || v_value);

EXCEPTION 
WHEN NO_DATA_FOUND THEN 
DBMS_OUTPUT.PUT_LINE("Invalid inventory ID!");

END;
/
show error

--price before
SELECT inv_id, inv_price, inv_qoh FROM INVENTORY WHERE inv_id = 1;

EXEC l4q3(1,10);

--price after
SELECT inv_id, inv_price, inv_qoh FROM INVENTORY WHERE inv_id = 1;
