--1a
CREATE FUNCTION pontbriand_f1 (p_n1 NUMBER, p_n2 NUMBER) RETURN NUMBER as
BEGIN
RETURN p_n1 * p_n2;
END;
/

--1b
SELECT pontbriand_f1(2,2) FROM DUAL;

--1c
CREATE OR REPLACE PROCEDURE pontbriand_p1 (p_o_id NUMBER, p_inv_id NUMBER, p_oq NUMBER) AS

v_o_date DATE;
v_inv_price NUMBER;
v_inv_oq NUMBER;

v_total NUMBER;

v_ol_quantity order_line.ol_quantity%TYPE;

v_flag NUMBER := 0;


BEGIN

SELECT o_date
INTO v_o_date
FROM orders
WHERE o_id = p_o_id;

v_flag := 1;

SELECT inv_price, inv_qoh 
INTO  v_inv_price, v_inv_oq
FROM inventory
WHERE inv_id = p_inv_id;

v_flag := 2;

SELECT ol_quantity
INTO v_ol_quantity
FROM order_line
WHERE o_id = p_o_id AND inv_id = p_inv_id;

IF v_ol_quantity = p_oq THEN
DBMS_OUTPUT.PUT_LINE('Nothing to update.');
ELSE
UPDATE order_line SET ol_quantity = p_oq
WHERE o_id = p_o_id AND inv_id = p_inv_id;

v_total := pontbriand_f1(v_inv_price, v_ol_quantity);
DBMS_OUTPUT.PUT_LINE('DATE:' || v_o_date);
DBMS_OUTPUT.PUT_LINE('Inv Id:' || p_inv_id);
DBMS_OUTPUT.PUT_LINE('Price:' || v_inv_price);
DBMS_OUTPUT.PUT_LINE('Order quantity:' || p_o_id);
DBMS_OUTPUT.PUT_LINE('Total:' || v_total);

END IF;

COMMIT;

EXCEPTION
WHEN NO_DATA_FOUND THEN
IF v_flag = 0 THEN
DBMS_OUTPUT.PUT_LINE('Order ID ERROR');
ELSIF v_flag = 1 THEN
DBMS_OUTPUT.PUT_LINE('Inventory ID ERROR');
ELSIF v_flag = 2 THEN
DBMS_OUTPUT.PUT_LINE('Combo of Order ID AND inv_id ERROR');
END IF;
END;
/

EXEC pontbriand_p1(1,1,1);
EXEC pontbriand_p1(999,1,1);
EXEC pontbriand_p1(1,999,1);
EXEC pontbriand_p1(1,3,1);


CREATE OR REPLACE PROCEDURE pontbriand_p2 (p_ctr NUMBER) AS

v_tax NUMBER;
v_total NUMBER;

BEGIN

IF p_ctr < 0 THEN
DBMS_OUTPUT.PUT_LINE('Error. The is negative');
ELSE

FOR i IN (SELECT inv_id, inv_price, color, inv_qoh FROM inventory) LOOP

v_tax := i.inv_price * p_ctr/100;
v_total := v_tax + i.inv_price;

DBMS_OUTPUT.PUT_LINE('ID ' || i.inv_id);
DBMS_OUTPUT.PUT_LINE('Price ' || i.inv_price);
DBMS_OUTPUT.PUT_LINE('Color ' || i.color);
DBMS_OUTPUT.PUT_LINE('QoH ' || i.inv_qoh);
DBMS_OUTPUT.PUT_LINE('Tax ' || v_tax);
DBMS_OUTPUT.PUT_LINE('Total ' || v_total);
DBMS_OUTPUT.PUT_LINE('|');

END LOOP;
END IF;
END;
/

EXEC pontbriand_p2(100);