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
	DBMS_OUTPUT.PUT_LINE('=========================================================================================');
	DBMS_OUTPUT.PUT_LINE('ITEM ID: ' || item_record.item_id || ' | ITEM DESC: ' ||
					item_record.item_desc || ' | CATEGORY ID: ' || item_record.cat_id);
	DBMS_OUTPUT.PUT_LINE('=========================================================================================');

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

--Q4

CONNECT des02/des02;
SET SERVEROUTPUT ON
SET linesize 300
SET pagesize 500

CREATE OR REPLACE PROCEDURE display_all_items_inv2 AS

CURSOR item_cur IS
SELECT item_id, item_desc, cat_id
	FROM item;

item_record item_cur%ROWTYPE;

CURSOR inventory_cur(pc_item_id item.item_id%TYPE) IS
SELECT inv_id, color, inv_size, inv_price, inv_qoh
	FROM inventory
		WHERE item_id = pc_item_id;

inventory_record inventory_cur%ROWTYPE;
item_value NUMBER;

BEGIN

item_value := 0;

OPEN item_cur;

FETCH item_cur INTO item_record;

WHILE item_cur%FOUND LOOP
	
	OPEN inventory_cur(item_record.item_id);
	FETCH inventory_cur INTO inventory_record;
	WHILE inventory_cur%FOUND LOOP
		item_value := item_value + (inventory_record.inv_price * inventory_record.inv_qoh);
		FETCH inventory_cur INTO inventory_record;
	END LOOP;
	CLOSE inventory_cur;
		
	DBMS_OUTPUT.PUT_LINE('=======================================================================================================================');
	DBMS_OUTPUT.PUT_LINE('ITEM ID: ' || item_record.item_id || ' | ITEM DESC: ' ||
					item_record.item_desc || ' | ITEM TOTAL VALUE: CAD$ ' || item_value || ' | CATEGORY ID: ' || item_record.cat_id);
DBMS_OUTPUT.PUT_LINE('=======================================================================================================================');

	OPEN inventory_cur(item_record.item_id);
	FETCH inventory_cur INTO inventory_record;
	WHILE inventory_cur%FOUND LOOP
		DBMS_OUTPUT.PUT_LINE('|      Inv Id: ' || inventory_record.inv_id || '   Color: ' ||
		inventory_record.color || '   Size: ' || inventory_record.inv_size || '   Price: CAD$ ' ||
		inventory_record.inv_price || '   Quantity: ' || inventory_record.inv_qoh || '   Value: CAD$ ' || inventory_record.inv_qoh * inventory_record.inv_price);
	FETCH inventory_cur INTO inventory_record;
	IF inventory_cur%NOTFOUND THEN
		DBMS_OUTPUT.PUT_LINE('.');
	END IF;
	END LOOP;
	CLOSE inventory_cur;
	FETCH item_cur INTO item_record;
	item_value := 0;
END LOOP;
CLOSE item_cur;
END;
/
show error;
EXEC display_all_items_inv2;
	
--Q5

CONNECT des04/des04;
SET SERVEROUTPUT ON
SET linesize 300
SET pagesize 500

CREATE OR REPLACE PROCEDURE cons_skill_updater(p_c_Id_IN NUMBER, p_certification_IN VARCHAR2) AS

CURSOR consultant_cur IS 
	SELECT c_id, c_first, c_last, c_email
		FROM consultant;

consultant_record consultant_cur%ROWTYPE;

CURSOR consultant_skills_cur(pc_consultant_id consultant.c_id%TYPE) IS
	SELECT cs.skill_id, s.skill_description, cs.certification
		FROM consultant_skill cs
			JOIN skill s
				ON cs.skill_id = s.skill_id
					WHERE cs.c_id = pc_consultant_id;

skill_record consultant_skills_cur%ROWTYPE;
ex_wrong_cert_found EXCEPTION;

BEGIN

IF p_certification_IN NOT LIKE 'Y' AND p_certification_IN NOT LIKE 'N' THEN
RAISE ex_wrong_cert_found;
END IF;

OPEN consultant_cur;

FETCH consultant_cur INTO consultant_record;

WHILE consultant_cur%FOUND LOOP
	DBMS_OUTPUT.PUT_LINE('======================================================================================================================================');
	DBMS_OUTPUT.PUT_LINE('CONSULTANT ID: ' || consultant_record.c_id || '     | FIRST NAME: ' || consultant_record.c_first || '     | LAST NAME: ' || consultant_record.c_last || '     | EMAIL: ' || consultant_record.c_email);
	DBMS_OUTPUT.PUT_LINE('======================================================================================================================================');

	OPEN consultant_skills_cur(consultant_record.c_id);
	FETCH consultant_skills_cur INTO skill_record;
	WHILE consultant_skills_cur%FOUND LOOP
	IF consultant_record.c_id = p_c_Id_IN THEN
	
		DBMS_OUTPUT.PUT_LINE('Skill ID: ' || skill_record.skill_id || '    | Skill 	Description: ' || skill_record.skill_description || '    | Old 	Certification Status: ' || skill_record.certification || '                    | New Certification status: ' || p_certification_IN);

		UPDATE consultant_skill
			SET certification = p_certification_IN 
				WHERE c_id = consultant_record.c_id AND skill_id = skill_record.skill_id;

 	ELSE
		DBMS_OUTPUT.PUT_LINE('Skill ID: ' || skill_record.skill_id || '     | Skill Description: ' || skill_record.skill_description || '                | Certification Status: ' || skill_record.certification);
		
	END IF;
	FETCH consultant_skills_cur INTO skill_record;
	IF consultant_skills_cur%NOTFOUND THEN
		DBMS_OUTPUT.PUT_LINE('.');
	END IF;
	END LOOP;
	CLOSE consultant_skills_cur;
FETCH consultant_cur INTO consultant_record;
END LOOP;
CLOSE consultant_cur;
EXCEPTION
WHEN ex_wrong_cert_found THEN
DBMS_OUTPUT.PUT_LINE('Invalid certification input type. Must be either Y or N.');
END;
/
show error

EXEC cons_skill_updater(100,'Z');
EXEC cons_skill_updater(100,'Y');
EXEC cons_skill_updater(105,'Y');