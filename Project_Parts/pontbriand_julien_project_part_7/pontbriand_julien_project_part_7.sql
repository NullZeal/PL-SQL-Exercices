-- Q1 ---------------------------------------------
SET linesize 300
SET pagesize 500
CONNECT des03/des03;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE display_all_fac_mem_for_loop AS

CURSOR fac_cur IS
SELECT f_id, f_last, f_first, f_rank 
	FROM faculty;

CURSOR student_cur(pc_f_id faculty.f_id%TYPE) IS
SELECT s_id, s_last, s_first, s_dob, s_class
	FROM student
		WHERE f_id = pc_f_id;

v_currentId faculty.f_id%TYPE;

BEGIN 

FOR c_index IN fac_cur LOOP
	DBMS_OUTPUT.PUT_LINE('====================================================================================================');
	DBMS_OUTPUT.PUT_LINE('FACULTY MEMBER ID: ' || c_index.f_id || ' - FIRST NAME:  ' || c_index.f_first || ' - LAST NAME: ' ||
						c_index.f_last || ' - Rank : ' || c_index.f_rank);
	DBMS_OUTPUT.PUT_LINE('====================================================================================================');

    v_currentId := c_index.f_id;

	FOR z_index IN student_cur(v_currentId) LOOP

		DBMS_OUTPUT.PUT_LINE('|       Student ID: ' || z_index.s_id || ' - First Name: ' || z_index.s_first || ' - Last Name: ' ||
						z_index.s_last || ' - Birthdate: ' || z_index.s_dob || ' - class: ' || z_index.s_class);
		IF student_cur%FOUND THEN
		DBMS_OUTPUT.PUT_LINE('---------');
		END IF;
		END LOOP;
	IF fac_cur%FOUND THEN
	DBMS_OUTPUT.PUT_LINE('|');
	END IF;
	END LOOP;
END;
/
show error;
EXEC display_all_fac_mem_for_loop;


-- Q2 --------------------------------------------

CONNECT des04/des04;
SET SERVEROUTPUT ON;
SET linesize 300
SET pagesize 500

CREATE OR REPLACE PROCEDURE display_all_consultants AS

CURSOR consultant_cur IS
SELECT c_id, c_first, c_last
	FROM consultant;

CURSOR consultant_skill_cur(pc_consultant_id consultant.c_id%TYPE) IS

SELECT s.skill_id, s.skill_description, cs.certification, cs.c_id
	FROM skill S
		JOIN consultant_skill cs
			ON s.skill_id = cs.skill_id
				WHERE cs.c_id = pc_consultant_id;

consultant_record consultant_cur%ROWTYPE;
skill_record consultant_skill_cur%ROWTYPE;

BEGIN

OPEN consultant_cur;

FETCH consultant_cur INTO consultant_record;

WHILE consultant_cur%FOUND LOOP
	DBMS_OUTPUT.PUT_LINE('=======================================================================');
	DBMS_OUTPUT.PUT_LINE('CONSULTANT ID: ' || consultant_record.c_id || '    FIRST NAME: ' || 
	consultant_record.c_first || '    LAST NAME: ' || consultant_record.c_last);
	DBMS_OUTPUT.PUT_LINE('=======================================================================');

	OPEN consultant_skill_cur(consultant_record.c_id);
	FETCH consultant_skill_cur INTO skill_record;

	WHILE consultant_skill_cur%FOUND LOOP
	DBMS_OUTPUT.PUT_LINE('|       ' || skill_record.skill_description || ' - Certification: ' || skill_record.certification);
	FETCH consultant_skill_cur INTO skill_record;
	IF consultant_skill_cur%FOUND THEN 
	DBMS_OUTPUT.PUT_LINE('---------');
	ELSE 
	DBMS_OUTPUT.PUT_LINE('.');
	END IF;
	END LOOP;
	CLOSE consultant_skill_cur;

FETCH consultant_cur INTO consultant_record;
END LOOP;

CLOSE consultant_cur;
END;
/
show error;
EXEC display_all_consultants;


--Q3 -----------------------------------------------------

CONNECT des02/des02;
SET SERVEROUTPUT ON
SET linesize 300
SET pagesize 500

CREATE OR REPLACE PROCEDURE display_all_items_inv AS

v_currentID item.item_id%TYPE;

BEGIN

FOR c_index IN (SELECT item_id, item_desc, cat_id FROM item) LOOP 
	DBMS_OUTPUT.PUT_LINE('=========================================================================================');
	DBMS_OUTPUT.PUT_LINE('ITEM ID: ' || c_index.item_id || ' | ITEM DESC: ' ||
					c_index.item_desc || ' | CATEGORY ID: ' || c_index.cat_id);
	DBMS_OUTPUT.PUT_LINE('=========================================================================================');

    v_currentID := c_index.item_id;

	FOR z_index IN (SELECT inv_id, color, inv_size, inv_price, inv_qoh FROM inventory WHERE item_id = v_currentID) LOOP
		DBMS_OUTPUT.PUT_LINE('|      Inv Id: ' || z_index.inv_id || '   Color: ' ||
		z_index.color || '   Size: ' || z_index.inv_size || '   Price: CAD$ ' ||
		z_index.inv_price || '   Quantity: ' || z_index.inv_qoh);
	END LOOP;
END LOOP;
END;
/
show error;
EXEC display_all_items_inv;


-- Q4 ----------------------------------------------

CONNECT des02/des02;
SET SERVEROUTPUT ON
SET linesize 300
SET pagesize 500

CREATE OR REPLACE PROCEDURE display_all_items_inv AS

v_item_value NUMBER;

BEGIN

v_item_value := 0;

FOR a_index IN (SELECT item_id, item_desc, cat_id FROM item) LOOP 

	FOR b_index IN (SELECT inv_price, inv_qoh FROM inventory WHERE item_id = a_index.item_id) LOOP
        v_item_value := v_item_value + (b_index.inv_price * b_index.inv_qoh);
    END LOOP;

	DBMS_OUTPUT.PUT_LINE('=========================================================================================');
	DBMS_OUTPUT.PUT_LINE('ITEM ID: ' || a_index.item_id || ' | ITEM DESC: ' ||
					a_index.item_desc || ' | ITEM VALUE: $CAD ' || v_item_value || ' | CATEGORY ID: ' || a_index.cat_id);
	DBMS_OUTPUT.PUT_LINE('=========================================================================================');

	FOR c_index IN (SELECT inv_id, color, inv_size, inv_price, inv_qoh FROM inventory WHERE item_id = a_index.item_id) LOOP
		DBMS_OUTPUT.PUT_LINE('|      Inv Id: ' || c_index.inv_id || '   Color: ' ||
		c_index.color || '   Size: ' || c_index.inv_size || '   Price: CAD$ ' ||
		c_index.inv_price || '   Quantity: ' || c_index.inv_qoh);
	END LOOP;
v_item_value := 0;
END LOOP;
END;
/
show error;
EXEC display_all_items_inv;

