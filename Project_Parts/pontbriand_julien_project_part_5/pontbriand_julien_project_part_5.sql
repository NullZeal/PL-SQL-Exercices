--Q1

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
DBMS_OUTPUT.PUT_LINE('==================');
DBMS_OUTPUT.PUT_LINE('ID : ' || v_term_id);
DBMS_OUTPUT.PUT_LINE('Desc : ' || v_term_desc);
DBMS_OUTPUT.PUT_LINE('Status : ' || v_status);
FETCH data_cursor INTO v_term_id, v_term_desc, v_status;
IF data_cursor%FOUND THEN
DBMS_OUTPUT.PUT_LINE('.');
END IF;
END LOOP;
CLOSE data_cursor;
END;
/
show error
EXEC show_data;

-- Q2

connect des02/des02;
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE show_data_2 AS

CURSOR data_cursor IS
	SELECT i.inv_id, i.color, i.inv_price, i.inv_qoh, NVL(it.item_desc,'No description')
		FROM inventory i
			JOIN item it
				ON i.item_id = it.item_id;
		
v_color inventory.color%TYPE;
v_price inventory.inv_price%TYPE;
v_qoh inventory.inv_price%TYPE;
v_desc item.item_desc%TYPE;
v_id inventory.inv_id%TYPE;

BEGIN

OPEN data_cursor;

FETCH data_cursor
	INTO v_id, v_color, v_price, v_qoh, v_desc;

WHILE data_cursor%FOUND LOOP

DBMS_OUTPUT.PUT_LINE('INVENTORY ID: ' || v_id || '    | DESCRIPTION: ' || v_desc || '    | PRICE: $CAD ' || v_price || 
					'    | COLOR: ' || v_color || '    | QOH: ' || v_qoh);


FETCH data_cursor
	INTO v_id, v_color, v_price, v_qoh, v_desc;
IF data_cursor%FOUND THEN 
DBMS_OUTPUT.PUT_LINE('|');
END IF;
END LOOP;

CLOSE data_cursor;

END;
/
show error;
EXEC show_data_2;

--Q3

connect des02/des02;
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE itemPriceUpdater(p_percent IN NUMBER) AS

CURSOR item_curr IS 
	SELECT i.inv_id, i.item_id, i.inv_price
		FROM inventory i
			JOIN item it
				ON i.item_id = it.item_id;
				
v_inv_id inventory.inv_id%TYPE;				
v_id inventory.item_id%TYPE;				
v_price inventory.inv_price%TYPE;
v_new_price NUMBER;

BEGIN

OPEN item_curr;

FETCH item_curr INTO v_inv_id, v_id, v_price;
	WHILE item_curr%FOUND LOOP
			v_new_price := v_price + v_price * (p_percent/100);
			UPDATE inventory SET inv_price = v_new_price WHERE item_id = v_id;
			
			DBMS_OUTPUT.PUT_LINE('Inventory ID #: ' || v_inv_id || ' |    Item ID #: ' || v_id || ' |    Old price: $CAD ' || 
			v_price || ' |    Increase in % : ' || p_percent || ' |    New price: $CAD ' || v_new_price);

		FETCH item_curr INTO v_inv_id, v_id, v_price;
		IF item_curr%FOUND THEN
		DBMS_OUTPUT.PUT_LINE('|');
		END IF;
	END LOOP;
CLOSE item_curr;
--COMMIT;
END;
/
show error;
EXEC itemPriceUpdater(10);

--Q4

connect scott/tiger
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE show_highest_paid_employees(p_empAmountToDisplay IN NUMBER) AS

CURSOR empCurr IS
	SELECT ename, sal 
		FROM emp
			ORDER BY sal DESC;
			
v_ename emp.ename%TYPE;
v_sal emp.sal%TYPE;

BEGIN

OPEN empCurr;

FETCH empCurr INTO v_ename, v_sal;
	FOR i IN 1..p_empAmountToDisplay LOOP
		DBMS_OUTPUT.PUT_LINE(v_ename || ' with a salary of : CAD$ ' || v_sal);
		FETCH empCurr INTO v_ename, v_sal;
	END LOOP;	
			
CLOSE empCUrr;
END;
/
show error

EXEC show_highest_paid_employees(2);
EXEC show_highest_paid_employees(10);
	
	
--Q5

connect scott/tiger
SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE show_top$_emp_for_x_top_sal(p_amountOftopSalaries IN NUMBER) AS

CURSOR empCurr IS
	SELECT ename, sal 
		FROM emp
			ORDER BY sal DESC;
			
v_ename emp.ename%TYPE;
v_sal emp.sal%TYPE;

v_value_checker NUMBER;
v_counter NUMBER;

BEGIN

v_counter := 0;
v_value_checker := 0;

OPEN empCurr;

	WHILE v_counter <= p_amountOftopSalaries 
			AND p_amountOftopSalaries > 0 
			
			LOOP
				FETCH empCurr INTO v_ename, v_sal;
				IF empCurr%FOUND THEN
					IF v_value_checker NOT LIKE v_sal THEN
						v_counter := v_counter + 1;
						v_value_checker := v_sal;
						IF v_counter <= p_amountOftopSalaries THEN
							DBMS_OUTPUT.PUT_LINE(v_ename || ' with a salary of : CAD$ ' || v_sal);
						END IF;
					ELSE
						DBMS_OUTPUT.PUT_LINE(v_ename || ' with a salary of : CAD$ ' || v_sal);
					END IF;
				ELSE v_counter := p_amountOftopSalaries +1;
				END IF;
			END LOOP;	
			
CLOSE empCUrr;
END;
/
show error

EXEC show_top$_emp_for_x_top_sal(2);
EXEC show_top$_emp_for_x_top_sal(10);