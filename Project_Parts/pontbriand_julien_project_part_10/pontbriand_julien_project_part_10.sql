------------Q1

connect des02/des02;

CREATE SEQUENCE customer_audit_sequence;

CREATE TABLE customer_audit(customer_audit_id NUMBER, customer_audit_audit_date DATE, customer_audi_user_audited VARCHAR2(20));

CREATE OR REPLACE TRIGGER customer_audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON customer

BEGIN
    INSERT INTO customer_audit(customer_audit_id, customer_audit_audit_date, customer_audi_user_audited)
    VALUES(customer_audit_sequence.NEXTVAL, sysdate, user);
END;
/

--TEST 1
SELECT * FROM customer_audit;
UPDATE customer SET c_last = 'test1' WHERE c_id = 1;
SELECT * FROM customer_audit;

--TEST 2
INSERT INTO customer(c_id, c_last) VALUES(999, 'Obama');
SELECT * FROM customer_audit;

--TEST 3
DELETE FROM customer WHERE c_id = 999;
SELECT * FROM customer_audit;

-----------Q2

CREATE SEQUENCE order_line_audit_sequence;

CREATE TABLE order_line_audit(ola_id NUMBER, ola_user VARCHAR(20), ola_audit_date DATE, ola_action_type VARCHAR2(30));

CREATE OR REPLACE TRIGGER order_line_audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON order_line

BEGIN
  IF INSERTING THEN
    INSERT INTO order_line_audit 
    VALUES(order_line_audit_sequence.NEXTVAL, user, sysdate, 'INSERT');
  ELSIF UPDATING THEN 
    INSERT INTO order_line_audit 
    VALUES(order_line_audit_sequence.NEXTVAL, user, sysdate, 'UPDATE');
  ELSIF DELETING THEN 
    INSERT INTO order_line_audit 
    VALUES(order_line_audit_sequence.NEXTVAL, user, sysdate, 'DELETE');
  END IF; 
END;
/

--TEST 1
SELECT * FROM order_line_audit;
UPDATE order_line SET ol_quantity = 1000 WHERE inv_id = 1 AND o_id = 1;
SELECT * FROM order_line_audit;

--TEST 2
INSERT INTO order_line(inv_id, o_id, ol_quantity) VALUES(1, 2, 2000);
SELECT * FROM order_line_audit;

--TEST 3
DELETE FROM order_line WHERE inv_id = 1 AND o_id = 2;
SELECT * FROM order_line_audit;


--------Q3

CREATE SEQUENCE order_line_row_audit_sequence2;

CREATE TABLE order_line_row_audit(olra_id NUMBER, olra_audit_date DATE, olra_old_quantity NUMBER);

CREATE OR REPLACE TRIGGER order_line_row_audit_trigger
AFTER UPDATE
ON order_line
FOR EACH ROW

BEGIN
    INSERT INTO order_line_row_audit(olra_id, olra_audit_date, olra_old_quantity) 
    VALUES (order_line_row_audit_sequence2.NEXTVAL, sysdate, :OLD.ol_quantity);
END;
/

--TEST 1
SELECT * FROM order_line_row_audit;
UPDATE order_line SET ol_quantity = 1000 WHERE inv_id = 1 AND o_id = 1;
SELECT * FROM order_line_row_audit;

--TEST 2
UPDATE order_line SET ol_quantity = 2000 WHERE inv_id = 1 AND o_id = 1;
SELECT * FROM order_line_row_audit;

--TEST 3
UPDATE order_line SET ol_quantity = 3000 WHERE inv_id = 1 AND o_id = 1;
SELECT * FROM order_line_row_audit;
