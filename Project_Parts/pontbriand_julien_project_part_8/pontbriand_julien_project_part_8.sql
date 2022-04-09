--------QUESTION 1

CONNECT des02/des02;

CREATE OR REPLACE PACKAGE order_package IS
  global_inv_id NUMBER(6);
  global_quantity NUMBER(6);

  PROCEDURE create_new_order (
    current_c_id NUMBER,
    current_meth_pmt VARCHAR2,
    current_os_id NUMBER);

  PROCEDURE create_new_order_line(current_o_id NUMBER);

  FUNCTION isQohEnough(p_inv_id NUMBER) RETURN BOOLEAN;

  FUNCTION getPackageGlobalInvId RETURN NUMBER;

END;
/

CREATE OR REPLACE PACKAGE BODY order_package IS

  FUNCTION getPackageGlobalInvId RETURN NUMBER AS
  BEGIN
    RETURN global_inv_id;
  END getPackageGlobalInvId;

  FUNCTION isQohEnough(p_inv_id NUMBER) RETURN BOOLEAN AS
    v_inv_qoh NUMBER;
    BEGIN

    SELECT inv_qoh
    INTO v_inv_qoh
    FROM inventory
    WHERE p_inv_id = inv_id;
    IF v_inv_qoh >= order_package.global_quantity THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END isQohEnough;

  PROCEDURE create_new_order_line(current_o_id NUMBER) AS
    BEGIN
    INSERT INTO order_line 
    VALUES(current_o_id, global_inv_id, global_quantity);
    COMMIT;
  END create_new_order_line;

  PROCEDURE create_new_order(current_c_id NUMBER, current_meth_pmt VARCHAR2, current_os_id NUMBER) AS

    current_o_id NUMBER;

    BEGIN

    SELECT MAX(o_id + 1) INTO current_o_id FROM ORDERS;
    
    INSERT INTO orders 
      VALUES (current_o_id,
              sysdate,
              current_meth_pmt,
              current_c_id,
              current_os_id);
    COMMIT;

    IF isQohEnough(global_inv_id) THEN
      create_new_order_line(current_o_id);
      UPDATE inventory 
      SET inv_qoh = inv_qoh - global_quantity
      WHERE inv_id = global_inv_id;
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Success! Order-line added my friend Abdul!');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Error. Cannot insert a new order-line because there is less quantity of the specified inventory item than requested amount!');
    END IF;
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Error! The inventory ID selected does not exist in the database, my friend Santa Claus!');
  END create_new_order;
END;
/
show error

BEGIN
  order_package.global_inv_id := 1;
  order_package.global_quantity := 12;
END;
/ 

--TESTER--
SET SERVEROUTPUT ON

SELECT * FROM inventory WHERE order_package.getPackageGlobalInvId = inv_id;
SELECT * FROM order_line WHERE order_package.getPackageGlobalInvId = inv_id;
BEGIN
  order_package.create_new_order(4,'CASH',5);
 END;
/
SELECT * FROM inventory WHERE order_package.getPackageGlobalInvId = inv_id;
SELECT * FROM order_line WHERE order_package.getPackageGlobalInvId = inv_id;
BEGIN
  order_package.create_new_order(4,'CASH',5);
 END;
/
SELECT * FROM inventory WHERE order_package.getPackageGlobalInvId = inv_id;
SELECT * FROM order_line WHERE order_package.getPackageGlobalInvId = inv_id;
BEGIN
  order_package.global_inv_id := 999;
  order_package.global_quantity := 12;
  order_package.create_new_order(4,'BITCOIN',5);
END;
/ 



------------QUESTION 2

connect des04/des04;

CREATE OR REPLACE PACKAGE softwarePackage IS
  PROCEDURE p1 (p_c_id NUMBER, p_skill_id NUMBER, p_status CHAR);
END;
/

CREATE OR REPLACE PACKAGE BODY softwarePackage IS

  PROCEDURE p1 (p_c_id NUMBER, p_skill_id NUMBER, p_status CHAR) AS
    
    e_bad_status EXCEPTION;
    e_match_exists EXCEPTION;
    pragma exception_init(e_match_exists,-1);

    v_flag NUMBER := 0;

    v_c_last consultant.c_last%TYPE;
    v_c_first consultant.c_first%TYPE;
    v_skill_description skill.skill_description%TYPE;
    v_certification consultant_skill.certification%TYPE;

    BEGIN
    IF p_status <> 'Y' AND p_status <> 'N' THEN
      RAISE e_bad_status;
    END IF;

    SELECT c_last, c_first INTO v_c_last, v_c_first FROM consultant WHERE c_id = p_c_id;

    v_flag := 1;

    SELECT skill_description INTO v_skill_description FROM skill WHERE skill_id = p_skill_id;

    INSERT INTO consultant_skill VALUES(p_c_id, p_skill_id, p_status);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('|');
    DBMS_OUTPUT.PUT_LINE('INSERT COMPLETE!');
    DBMS_OUTPUT.PUT_LINE('|');

    SELECT certification INTO v_certification FROM consultant_skill WHERE p_c_id = c_id AND skill_id = p_skill_id;

    DBMS_OUTPUT.PUT_LINE('Last Name:' || v_c_last);
    DBMS_OUTPUT.PUT_LINE('First Name:' || v_c_first);
    DBMS_OUTPUT.PUT_LINE('Skill Description:' || v_skill_description);
    DBMS_OUTPUT.PUT_LINE('Certification Status:' || v_certification);
    DBMS_OUTPUT.PUT_LINE('|');

    EXCEPTION 
    WHEN e_bad_status THEN
      DBMS_OUTPUT.PUT_LINE('Error. Certification status input must be either Y or N. Check your input again please!');
    WHEN e_match_exists THEN
      DBMS_OUTPUT.PUT_LINE('Error. Consultant ID and Skill ID match already exist in the DB my friend Obama!');
    WHEN NO_DATA_FOUND THEN
    IF v_flag = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Error. Consultant ID does not exist in the DB my friend Lota!');
    ELSIF v_flag = 1 THEN
      DBMS_OUTPUT.PUT_LINE('Error. Skill ID does not exist in the DB my friend Javier!');
    END IF;
    END p1;
END;
/
show error

SET SERVEROUTPUT ON
BEGIN 
softwarePackage.p1(9999,2,'N');
softwarePackage.p1(100,999999,'N');
softwarePackage.p1(100,1,'Z');
softwarePackage.p1(100,9,'N');
softwarePackage.p1(100,2,'N');
softwarePackage.p1(100,2,'N');
END;
/
