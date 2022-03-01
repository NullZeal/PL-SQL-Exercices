--Q1
SET linesize 300
SET pagesize 500
CONNECT des03/des03;
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE display_all_fac_mem AS

CURSOR fac_cur IS

SELECT f_id, f_last, f_first, f_rank 
	FROM faculty;

CURSOR student_cur(pc_f_id faculty.f_id%TYPE) IS
SELECT s_id, s_last, s_first, s_dob, s_class
	FROM student
		WHERE f_id = pc_f_id;

faculty_record fac_cur%ROWTYPE;
student_record student_cur%ROWTYPE;

BEGIN 

OPEN fac_cur;

FETCH fac_cur INTO faculty_record;

WHILE fac_cur%FOUND LOOP
	DBMS_OUTPUT.PUT_LINE('====================================================================================================');
	DBMS_OUTPUT.PUT_LINE('FACULTY MEMBER ID: ' || faculty_record.f_id || ' - FIRST NAME:  ' || faculty_record.f_first || ' - LAST NAME: ' ||
						faculty_record.f_last || ' - Rank : ' || faculty_record.f_rank);
	DBMS_OUTPUT.PUT_LINE('====================================================================================================');
	
	OPEN student_cur(faculty_record.f_id);
	FETCH student_cur INTO student_record;
	IF student_cur%NOTFOUND THEN
		DBMS_OUTPUT.PUT_LINE('***** NO STUDENT FOUND FOR THIS FACULTY MEMBER! *****');
	END IF;
	WHILE student_cur%FOUND LOOP
		DBMS_OUTPUT.PUT_LINE('|       Student ID: ' || student_record.s_id || ' - First Name: ' || student_record.s_first || ' - Last Name: ' ||
						student_record.s_last || ' - Birthdate: ' || student_record.s_dob || ' - class: ' || student_record.s_class);
		FETCH student_cur INTO student_record;
		IF student_cur%FOUND THEN
		DBMS_OUTPUT.PUT_LINE('---------');
		END IF;
		END LOOP;
		CLOSE student_cur;
	FETCH fac_cur INTO faculty_record;
	IF fac_cur%FOUND THEN
	DBMS_OUTPUT.PUT_LINE('|');
	END IF;
	END LOOP;
	CLOSE fac_cur;
END;
/
show error;
EXEC display_all_fac_mem;

--Q2

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
	DBMS_OUTPUT.PUT_LINE('=========================================================================');
	DBMS_OUTPUT.PUT_LINE('CONSULTANT ID: ' || consultant_record.c_id || '    FIRST NAME: ' || 
	consultant_record.c_first || '    LAST NAME: ' || consultant_record.c_last);
	DBMS_OUTPUT.PUT_LINE('=========================================================================');

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

--Q3

CONNECT des02/des02;
SET SERVEROUTPUT ON
SET linesize 300
SET pagesize 500

CREATE OR REPLACE PROCEDURE display_all_items_inv AS

CURSOR item_cur IS
SELECT item_id, item_desc, cat_id
	FROM item;

item_record item_cur%ROWTYPE;

CURSOR inventory_cur(pc_item_id item.item_id%TYPE) IS
SELECT inv_id, color, inv_size, inv_price, inv_qoh
	FROM inventory
		WHERE item_id = pc_item_id;

inventory_record inventory_cur%ROWTYPE;

BEGIN

OPEN item_cur;

FETCH item_cur INTO item_record;
WHILE item_cur%FOUND LOOP
	DBMS_OUTPUT.PUT_LINE('===================================================================================');
	DBMS_OUTPUT.PUT_LINE('ITEM ID: ' || item_record.item_id || ' | ITEM DESC: ' ||
					item_record.item_desc || ' | CATEGORY ID: ' || item_record.cat_id);
	DBMS_OUTPUT.PUT_LINE('===================================================================================');

	OPEN inventory_cur(item_record.item_id);
	FETCH inventory_cur INTO inventory_record;
	WHILE inventory_cur%FOUND LOOP
		DBMS_OUTPUT.PUT_LINE('|      Inv Id: ' || inventory_record.inv_id || '   Color: ' ||
		inventory_record.color || '   Size: ' || inventory_record.inv_size || '   Price: CAD$ ' ||
		inventory_record.inv_price || '   Quantity: ' || inventory_record.inv_qoh);
	FETCH inventory_cur INTO inventory_record;
	IF inventory_cur%NOTFOUND THEN
		DBMS_OUTPUT.PUT_LINE('.');
	END IF;
	END LOOP;
	CLOSE inventory_cur;
	FETCH item_cur INTO item_record;
END LOOP;
CLOSE item_cur;
END;
/
show error;
EXEC display_all_items_inv;

Question 3:
Run script 7clearwater in schemas des02

Create a procedure to display all items (item_id, item_desc, cat_id) 
under each item, display all the inventories belong to it.

--Q4

	
--Q5






 








Question 4:
Modify question 3 to display beside the item description the value of
the item (value = inv_price * inv_qoh).




Question 5:
Run script 7software in schemas des04
Create a procedure that accepts a consultant id, and a character used to
update the status (certified or not) of all the SKILLs belonged to the
consultant inserted.
Display 4 information about the consultant such as id, name, …Under each
consultant display all his/her skill (skill description) and the OLD and NEW
status of the skill (certified or not).
