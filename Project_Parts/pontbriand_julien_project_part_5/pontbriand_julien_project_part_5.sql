connect des03/des03;
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE show_data AS

CURSOR data_cursor IS
	SELECT term_id, NVL(term_desc, 'Unknown Season and Year'), NVL(status, 'Unknown Status')
		FROM term;
		
v_term_id term.term_id%TYPE;
v_term_desc term.term_desc%TYPE;
v_status term.status%TYPE;

BEGIN

OPEN data_cursor;

FETCH data_cursor
	INTO v_term_id, v_term_desc, v_status;
	
WHILE data_cursor%FOUND LOOP
DBMS_OUTPUT.PUT_LINE('============');
DBMS_OUTPUT.PUT_LINE('ID : ' || v_term_id);
DBMS_OUTPUT.PUT_LINE('Desc : ' || v_term_desc);
DBMS_OUTPUT.PUT_LINE('Status : ' || v_status);
FETCH data_cursor INTO v_term_id, v_term_desc, v_status;
END LOOP;

CLOSE data_cursor;

EXCEPTION 
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Data request error for term table.');

END;
/
show error
EXEC show_data;


-- Q2

connect des02/des02;
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE show_data_2 AS

CURSOR data_cursor IS
	SELECT i.color, i.inv_price, i.inv_qoh, NVL(it.item_desc,'No description')
		FROM inventory i
			JOIN item it
				ON i.item_id = it.item_id;
		
v_color inventory.color%TYPE;
v_price inventory.inv_price%TYPE;
v_qoh inventory.inv_price%TYPE;
v_desc item.item_desc%TYPE;

BEGIN

OPEN data_cursor;

FETCH data_cursor
	INTO v_color, v_price, v_qoh, v_desc;

WHILE data_cursor%FOUND LOOP
DBMS_OUTPUT.PUT_LINE('============');
DBMS_OUTPUT.PUT_LINE(' Item color : ' || v_color);
DBMS_OUTPUT.PUT_LINE('Price : ' || v_price);
DBMS_OUTPUT.PUT_LINE('QOH : ' || v_qoh);
DBMS_OUTPUT.PUT_LINE('DESC : ' || v_desc);

FETCH data_cursor
	INTO v_color, v_price, v_qoh, v_desc;
END LOOP;

CLOSE data_cursor;

END;
/

EXEC show_data_2;


--Q3

connect des02/des02;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE itemPriceUpdater(p_percent IN NUMBER) AS

CURSOR item_curr IS 
	SELECT i.item_id, i.inv_price
		FROM inventory i
			JOIN item it
				ON i.item_id = it.item_id;
				
v_id inventory.item_id%TYPE;				
v_price inventory.inv_price%TYPE;
v_new_price NUMBER;

BEGIN

OPEN item_curr;

FETCH item_curr INTO v_id, v_price;
	WHILE item_curr%FOUND LOOP
			v_new_price := v_price + v_price * p_percent/100;
			UPDATE inventory SET inv_price = v_new_price WHERE item_id = v_id;
			DBMS_OUTPUT.PUT_LINE('Item ID # ' || v_id || ' had a price of : ' || v_price || ' that has changed to :' || v_new_price);

		FETCH item_curr INTO v_id, v_price;
	END LOOP;
CLOSE item_curr;
END;
/

EXEC itemPriceUpdater(10);

--Q4

connect scott/tiger
SET SERVEROUTPUT ON

CREATE OR REPLACE A PROCEDURE show_highest_paid_employee(p_amountOfTopPaidEmployees IN NUMBER) AS

CURSOR empCurr IS




Create a procedure that accepts a number represent the number of employees
who earns the highest salary. Display employee name and his/her salary
Ex: SQL> exec L5Q4(2)
SQL> top 2 employees are
KING 5000
FORD 3000






	
	
	