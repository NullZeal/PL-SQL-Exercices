--Q1 A
connect des02/des02;

CREATE OR REPLACE FUNCTION julien_pontbriand_f1(p_num1_in NUMBER, p_num2_in NUMBER) RETURN NUMBER AS

v_product NUMBER;

BEGIN

v_product := p_num1_in * p_num2_in;

RETURN v_product;
END;
/

--Q1 B
SELECT julien_pontbriand_f1(2,2) FROM DUAL;

--Q1 C
SET SERVEROUTPUT ON;
connect des02/des02;
CREATE OR REPLACE PROCEDURE julien_pontbriand_p1(p_o_id_in NUMBER, p_inv_id_in NUMBER, p_oq_in NUMBER) AS

v_o_id NUMBER;
v_inv_id NUMBER;
v_date DATE;

v_combinaison NUMBER;

v_order_price NUMBER;
v_oq NUMBER;


v_f_result NUMBER;

v_error VARCHAR2(30);

BEGIN

v_error := 'oid_missing';

SELECT o_date
INTO v_date
FROM orders
WHERE o_id = p_o_id_in;

SELECT o_id 
INTO v_o_id 
FROM orders 
WHERE p_o_id_in = o_id;

SELECT inv_id 
INTO v_inv_id
FROM order_line
WHERE p_o_id_in = o_id AND inv_id = p_inv_id_in;

v_error := 'invid_missing';

SELECT i.inv_id
INTO v_combinaison 
FROM inventory i
JOIN order_line ol
ON i.inv_id = ol.inv_id
WHERE i.inv_id = p_inv_id_in AND ol.o_id = p_o_id_in;

SELECT i.inv_price, i.inv_qoh
INTO v_order_price, v_oq
FROM inventory i
JOIN order_line ol
ON i.inv_id = ol.inv_id
WHERE i.inv_id = p_inv_id_in AND ol.o_id = p_o_id_in;

v_f_result := julien_pontbriand_f1(v_order_price, v_oq);

DBMS_OUTPUT.PUT_LINE('The date is : ' || v_date);
DBMS_OUTPUT.PUT_LINE('The inv id is : ' || p_inv_id_in);
DBMS_OUTPUT.PUT_LINE('The order quantity is: ' || v_oq);
DBMS_OUTPUT.PUT_LINE('The total of the order is: ' || v_f_result || '$CAD');


EXCEPTION

WHEN NO_DATA_FOUND THEN
IF v_error = 'invid_missing' THEN
DBMS_OUTPUT.PUT_LINE('An invalid order ID has been entered my friend!');

ELSIF v_error = 'oid_missing' THEN
DBMS_OUTPUT.PUT_LINE('An invalid inventory ID has been entered my friend!');
END IF;
END;
/

EXEC julien_pontbriand_p1(1,1,1);
EXEC julien_pontbriand_p1(1000,1,1);


--Q2

connect des02/des02;
SET SERVEROUTPUT ON
SET linesize 300
SET pagesize 500
CREATE OR REPLACE PROCEDURE julien_pontbriand_p2(p_tax_rate NUMBER) AS

CURSOR inventory_cur IS
SELECT inv_id, inv_price, color, inv_qoh
	FROM inventory;


inventory_record inventory_cur%ROWTYPE;

price_with_tax NUMBER;

BEGIN

IF p_tax_rate < 0 THEN

DBMS_OUTPUT.PUT_LINE('The Tax rate is negative and therefore the procedure cannot work. Try with a positive tax value.');

ELSE

OPEN inventory_cur;
FETCH inventory_cur INTO inventory_record;
WHILE inventory_cur%FOUND LOOP
	DBMS_OUTPUT.PUT_LINE('| Inv Id: ' || inventory_record.inv_id || '   Price: CAD$ ' || inventory_record.inv_price || '   Color: ' ||  inventory_record.color || '  Quantity: ' || inventory_record.inv_qoh 
          ||  '   Country Tax: ' || p_tax_rate || '%  ' || ' value with tax : ' 
        || inventory_record.inv_price * (1 + (p_tax_rate /100) * inventory_record.inv_qoh ));
	FETCH inventory_cur INTO inventory_record;
	IF inventory_cur%NOTFOUND THEN
		DBMS_OUTPUT.PUT_LINE('.');
	END IF;
	END LOOP;
CLOSE inventory_cur;
END IF;
END;
/
show error;
EXEC julien_pontbriand_p2(-10);
EXEC julien_pontbriand_p2(10);

-- Q3 

connect des02/des02;
SET SERVEROUTPUT ON
SET linesize 300
SET pagesize 500
CREATE OR REPLACE PROCEDURE julien_pontbriand_p3 AS

v_date DATE;
v_date_result NUMBER;

BEGIN
SELECT SYSDATE INTO v_date FROM DUAL;
FOR cur_index IN (SELECT o_id, o_methpmt, o_date FROM orders) LOOP
    v_date_result := cur_index.o_date - v_date;
    DBMS_OUTPUT.PUT_LINE('OrderID : ' || cur_index.o_id || ' Method of payment ' || cur_index.o_methpmt || ' date : ' || cur_index.o_date || 'days between order date' || v_date_result);
    END LOOP;
END;
/
EXEC julien_pontbriand_p3;

--
