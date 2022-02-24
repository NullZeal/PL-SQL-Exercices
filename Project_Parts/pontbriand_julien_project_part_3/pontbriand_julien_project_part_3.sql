SET linesize 180
SET pagesize 300

-- QUESTION 1
connect scott/tiger;
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE giveEmpInfo (p_empno IN NUMBER) AS
v_dept_name VARCHAR2(20);
v_emp_name VARCHAR2(20);
v_initial_salary NUMBER;

v_annual_salary NUMBER;
v_total_salary NUMBER;
v_commission NUMBER;

BEGIN

SELECT NVL(d.DNAME,'Unknown'), e.ename, e.sal, NVL(e.comm,0)
	INTO v_dept_name, v_emp_name, v_initial_salary, v_commission
		FROM emp e 
			JOIN dept d 
				ON e.deptno = d.deptno
					WHERE e.empno = p_empno;
					
v_annual_salary := v_initial_salary * 12;
v_total_salary := v_annual_salary + v_commission;

DBMS_OUTPUT.PUT_LINE('Employee Number: ' || p_empno);
DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_emp_name); 
DBMS_OUTPUT.PUT_LINE('Employee department: ' || v_dept_name); 
DBMS_OUTPUT.PUT_LINE('Employee monthly salary : ' || v_initial_salary); 
DBMS_OUTPUT.PUT_LINE('Employee annual salary : ' || v_annual_salary);
DBMS_OUTPUT.PUT_LINE('Employee commission : ' || v_commission); 
DBMS_OUTPUT.PUT_LINE('Employee total salary with commission: ' || v_total_salary); 

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('Error - No employee has that number associated with it.');
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('An error has occured.');
END;
/
show error;

exec giveEmpInfo (7839);
exec giveEmpInfo (7499);
exec giveEmpInfo (99);

------------------------------------------------------------------------------------------------------------

-- QUESTION 2
connect des02/des02;
SET SERVEROUTPUT ON

update item set item_desc = ''WHERE item_id = 2;

CREATE OR REPLACE PROCEDURE showItemDescription(p_inv_id_in IN NUMBER) AS

v_inv_price NUMBER;
v_inv_color VARCHAR2(20);
v_inv_quantity NUMBER;
v_inv_item_id NUMBER;
v_item_desc varchar2(30);
v_item_value NUMBER;

BEGIN

SELECT inv.inv_price, inv.color, inv.inv_qoh, inv.item_id, NVL(i.item_desc, 'No desc.')
	INTO v_inv_price, v_inv_color, v_inv_quantity, v_inv_item_id, v_item_desc
		FROM inventory inv
			JOIN item i
				ON inv.item_id = i.item_id
					WHERE inv.inv_id = p_inv_id_in;
				
v_item_value := v_inv_quantity * v_inv_price;
					
DBMS_OUTPUT.PUT_LINE('Item description: ' || v_item_desc); 
DBMS_OUTPUT.PUT_LINE('Item price: $CAD ' || v_inv_price); 
DBMS_OUTPUT.PUT_LINE('Item Color: ' || v_inv_color); 
DBMS_OUTPUT.PUT_LINE('Quantity: ' || v_inv_quantity); 
DBMS_OUTPUT.PUT_LINE('Item total value: $CAD ' || v_item_value); 

EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Inventory ID # ' || p_inv_id_in || ' does not exist in the database.');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('An error has occured.');

END;
/
show error;

exec showItemDescription(1);
exec showItemDescription(32);
exec showItemDescription(33);


--------------------------------------------------------------------------------------------------------

-- Question 3:
connect des03/des03;
SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION findAge(p_person_birthday_date IN DATE) RETURN NUMBER AS

v_age_in_days NUMBER;
v_age_in_years NUMBER;

BEGIN

v_age_in_days := SYSDATE - TO_DATE(p_person_birthday_date); 
v_age_in_years := FLOOR(v_age_in_days / 365.28);

RETURN v_age_in_years;
END;
/
show error;

CREATE OR REPLACE PROCEDURE displayStudentInfos(p_student_id_in IN NUMBER) AS

v_first_name VARCHAR2(30);
v_last_name VARCHAR2(30);
v_birthdate DATE;
v_age NUMBER;

BEGIN

SELECT s_first, s_last, s_dob
	INTO v_first_name, v_last_name, v_birthdate
		FROM student 
			WHERE s_id = p_student_id_in;
			
v_age := findAge(v_birthdate);

DBMS_OUTPUT.PUT_LINE('Student name is: ' || v_first_name);
DBMS_OUTPUT.PUT_LINE('Student birthdate is: ' || v_birthdate);
DBMS_OUTPUT.PUT_LINE('Student age is: ' || v_age);

EXCEPTION

WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('No student found with ID # : ' || p_student_id_in);
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('An error has occured.');

END;
/
show error;

EXEC displayStudentInfos(1);
EXEC displayStudentInfos(2);
EXEC displayStudentInfos(3);
EXEC displayStudentInfos(6);
EXEC displayStudentInfos(999);

---------------------------------------------------------------------------------------------------------

-- QUESTION 4 
connect des04/des04;

CREATE OR REPLACE FUNCTION does_skill_id_Exist(p_c_id_in IN NUMBER, p_skill_id_in IN NUMBER) RETURN NUMBER AS

v_counter_id NUMBER;
v_counter_skill NUMBER;
v_output NUMBER;

BEGIN

SELECT COUNT(*) 
	INTO v_counter_id
		FROM consultant
			WHERE (c_id = p_c_id_in);
SELECT COUNT(*) 
	INTO v_counter_skill
		FROM skill
			WHERE (skill_id = p_skill_id_in);
			
IF v_counter_skill = 1 AND v_counter_id = 0 THEN
v_output := 2;

ELSIF v_counter_skill = 0 AND v_counter_id = 1 THEN
v_output := 1;

ELSIF v_counter_skill = 0 AND v_counter_id = 0 THEN
v_output := 0;

END IF;

RETURN v_output;
END;
/

SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE insert_or_update(p_consultant_id IN NUMBER, p_skill_id_in IN NUMBER, p_certification_status IN VARCHAR2) AS

v_consultant_first_name VARCHAR2(30);
v_consultant_last_name VARCHAR2(30);
v_skill_description VARCHAR2(50);

v_certification_status VARCHAR2(8);
v_match NUMBER;

ex_wrong_cert_found EXCEPTION;

BEGIN

SELECT c_first, c_last
	INTO v_consultant_first_name, v_consultant_last_name
		FROM consultant
			WHERE c_id = p_consultant_id;
		
SELECT skill_description
	INTO v_skill_description
		FROM skill
			WHERE skill_id = p_skill_id_in;

CASE

WHEN p_certification_status = 'Y' THEN
v_certification_status := v_certification_status;

WHEN p_certification_status = 'N' THEN
v_certification_status := v_certification_status;
END CASE;

SELECT COUNT(*) 
	INTO v_match
		FROM consultant_skill
			WHERE c_id = p_consultant_id AND skill_id = p_skill_id_in;
		
IF v_match = 0 THEN
	INSERT 
		INTO consultant_skill (c_id, skill_id, certification)
			VALUES (p_consultant_id, p_skill_id_in, p_certification_status);
			
	DBMS_OUTPUT.PUT_LINE('New entry added to Database!');

ELSE 
	SELECT certification 
		INTO v_certification_status
			FROM consultant_skill
				WHERE c_id = p_consultant_id AND skill_id = p_skill_id_in;
	
	IF  v_certification_status = p_certification_status THEN
	DBMS_OUTPUT.PUT_LINE('Values are the same, no need for update!');

	ELSE
		UPDATE consultant_skill
			SET certification = p_certification_status
				WHERE (c_id = p_consultant_id) AND (skill_id = p_skill_id_in);
				
	DBMS_OUTPUT.PUT_LINE('Database Updated!');
	END IF;
	
END IF;

COMMIT;

DBMS_OUTPUT.PUT_LINE('Consultant first name: ' || v_consultant_first_name);
DBMS_OUTPUT.PUT_LINE('Consultant last name: ' || v_consultant_last_name);
DBMS_OUTPUT.PUT_LINE('Skill Description: ' || v_skill_description);
								
EXCEPTION

WHEN NO_DATA_FOUND THEN 
IF does_skill_id_Exist(p_consultant_id, p_skill_id_in) = 0 THEN
	DBMS_OUTPUT.PUT_LINE('Both Consultant ID AND Skill ID input do not exist in the database.');

ELSIF does_skill_id_Exist(p_consultant_id, p_skill_id_in) = 1 THEN
	DBMS_OUTPUT.PUT_LINE('Skill ID input does not exist in the database.');	
	
ELSIF does_skill_id_Exist(p_consultant_id, p_skill_id_in) = 2 THEN
	DBMS_OUTPUT.PUT_LINE('Consultant ID input does not exist in the database.');
END IF;

WHEN CASE_NOT_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Certification Status can only be Y or N.');

END;
/
show error
SET SERVEROUTPUT ON
SELECT * FROM consultant_skill;

EXEC insert_or_update(999999,8,'Y');
EXEC insert_or_update(104,999999,'Y');
EXEC insert_or_update(9999999,8121123,'Z');
EXEC insert_or_update(9999999,81231123,'Y');
EXEC insert_or_update(100,2,'ZZZ');
EXEC insert_or_update(101,2,'ZZZZ3r32fd');
EXEC insert_or_update(101,4,'N');

EXEC insert_or_update(100,2,'N');
EXEC insert_or_update(100,2,'N');
EXEC insert_or_update(100,2,'Y');
EXEC insert_or_update(102,8,'Y');

SELECT * FROM consultant_skill;
