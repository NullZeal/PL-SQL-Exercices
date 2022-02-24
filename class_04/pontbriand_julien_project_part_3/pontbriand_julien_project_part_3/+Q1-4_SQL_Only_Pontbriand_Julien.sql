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

SELECT d.DNAME, e.ename, e.sal, e.comm
	INTO v_dept_name, v_emp_name, v_initial_salary, v_commission
		FROM emp e 
			JOIN dept d 
				ON e.deptno = d.deptno
					WHERE e.empno = p_empno;

v_annual_salary := v_initial_salary * 12;
v_total_salary := v_annual_salary;

IF v_commission IS NOT NULL THEN
v_total_salary := v_annual_salary + v_commission;
END IF;

DBMS_OUTPUT.PUT_LINE('Employee Number ' || p_empno || ' is ' || v_emp_name || '. He earns $'|| v_total_salary || ' a year, commission included, and his department name is : ' || v_dept_name);

EXCEPTION 
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('Error - No employee has that number associated with it.');
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE('An error has occured.');
END;
/
show error;
-- TEST 1 : 5000 MONTHLY SALARY, NO COMMISSION
exec giveEmpInfo (7839);
-- TEST 2 : 1600 MONTHLY SALARY * 12 = 19200 + 300 COMMISSION = 19500
exec giveEmpInfo (7499);
-- TEST 3 : DOES NOT EXIST IN DATABASE
exec giveEmpInfo (99);


------------------------------------------------------------------------------------------------------------


-- QUESTION 2
connect des02/des02;
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE showItemDescription(p_inv_id_in IN NUMBER) AS

v_inv_price NUMBER;
v_inv_color VARCHAR2(20);
v_inv_quantity NUMBER;
v_inv_item_id NUMBER;

v_item_desc varchar2(30);

v_item_value NUMBER;

BEGIN

SELECT inv.inv_price, inv.color, inv.inv_qoh, inv.item_id, i.item_desc
	INTO v_inv_price, v_inv_color, v_inv_quantity, v_inv_item_id, v_item_desc
		FROM inventory inv
			JOIN item i
				ON inv.item_id = i.item_id
					WHERE inv.inv_id = p_inv_id_in;
				
v_item_value := v_inv_quantity * v_inv_price;
					
DBMS_OUTPUT.PUT_LINE(chr(10) 	|| 'Item description: ' || v_item_desc || ' --------- ' 
								|| 'Item price: $CAD ' || v_inv_price || ' --------- '  
								|| 'Item Color: ' || v_inv_color || ' --------- '  
								|| 'Quantity: ' || v_inv_quantity || ' --------- '  
								|| 'Item total value: $CAD ' || v_item_value);
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Inventory ID # ' || p_inv_id_in || ' does not exist in the database.');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('An error has occured.');

END;
/
show error;
-- TEST 1 : ID 1
exec showItemDescription(1);
-- TEST 2 : ID 32
exec showItemDescription(32);
-- TEST 3 : ID 33, does not exist in database
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

DBMS_OUTPUT.PUT_LINE('Student name is: ' || v_first_name || ' ' || v_last_name || ', student birthdate is: ' || v_birthdate || ', and student age is: ' || v_age);

EXCEPTION

WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('No student found with ID # : ' || p_student_id_in);
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('An error has occured.');

END;
/
show error;
-- TEST 1 : 
EXEC displayStudentInfos(1);
-- TEST 2 : 
EXEC displayStudentInfos(2);
-- TEST 3 : 
EXEC displayStudentInfos(6);
-- TEST 4 : Student ID does not exist
EXEC displayStudentInfos(999);



---------------------------------------------------------------------------------------------------------



-- QUESTION 4 
connect des04/des04;
SET SERVEROUTPUT ON
CREATE OR REPLACE FUNCTION does_Skill_SkillID_Exist(p_skill_id NUMBER) RETURN BOOLEAN AS

COUNTER NUMBER;

BEGIN

SELECT COUNT(*) 
	INTO COUNTER
		FROM skill
			WHERE (skill_id = p_skill_id);

IF( COUNTER = 0 )
  THEN
	RETURN FALSE;
ELSE
	RETURN TRUE;
END IF;
END;
/

CREATE OR REPLACE FUNCTION does_Consultant_CID_Exist(p_consultant_id NUMBER) RETURN BOOLEAN AS

COUNTER NUMBER;

BEGIN

SELECT COUNT(*) 
	INTO COUNTER
		FROM consultant
			WHERE (c_id = p_consultant_id);

IF( COUNTER = 0 )
  THEN
	RETURN FALSE;
ELSE
	RETURN TRUE;
END IF;
END;
/

CREATE OR REPLACE FUNCTION does_CID_SKILLID_MatchExist(p_consultant_id NUMBER, p_skill_id NUMBER) RETURN BOOLEAN AS

COUNTER NUMBER;

BEGIN

SELECT COUNT(*) 
	INTO COUNTER
		FROM consultant_skill
			WHERE (c_id = p_consultant_id) AND (skill_id = p_skill_id);

IF( COUNTER = 0 )
  THEN
	RETURN FALSE;
ELSE
	RETURN TRUE;
END IF;
END;
/

SET SERVEROUTPUT ON

CREATE OR REPLACE PROCEDURE insert_or_update(p_consultant_id IN NUMBER, p_skillid IN NUMBER, p_certification_status IN VARCHAR2) AS

v_c_id_match NUMBER;
v_certification VARCHAR2(20);
v_consultant_first_name VARCHAR2(30);
v_consultant_last_name VARCHAR2(30);
v_skill_description VARCHAR2(50);

BEGIN

CASE 
	WHEN p_certification_status = 'Y' THEN
		v_certification := v_certification;
	
	WHEN p_certification_status = 'N' THEN
		v_certification := v_certification;
END CASE;

IF (does_Consultant_CID_Exist(p_consultant_id) = FALSE) AND (does_Skill_SkillID_Exist(p_skillid) = FALSE) THEN
	DBMS_OUTPUT.PUT_LINE('Both Consultant ID and skill ID are not present in the database.');

ELSIF does_Consultant_CID_Exist(p_consultant_id) = FALSE THEN
	DBMS_OUTPUT.PUT_LINE('Consultant Id input is not present in the database.');
	
ELSIF does_Skill_SkillID_Exist(p_skillid) = FALSE THEN 
	DBMS_OUTPUT.PUT_LINE('Skill ID input is not present in the database.');
	
ELSIF does_CID_SKILLID_MatchExist(p_consultant_id, p_skillid) = FALSE THEN
	INSERT 
		INTO consultant_skill (c_id, skill_id, certification)
			VALUES (p_consultant_id, p_skillid, p_certification_status);
			
	DBMS_OUTPUT.PUT_LINE('New entry added to Database!');

ELSE 
	UPDATE consultant_skill
		SET c_id = p_consultant_id,
			skill_id = p_skillid,
			certification = p_certification_status
				WHERE (c_id = p_consultant_id) AND (skill_id = p_skillid);
				
	DBMS_OUTPUT.PUT_LINE('Database Updated!');
	
END IF;

SELECT c_first, c_last
	INTO v_consultant_first_name, v_consultant_last_name
		FROM consultant
			WHERE c_id = p_consultant_id;
		
SELECT skill_description
	INTO v_skill_description
		FROM skill
			WHERE skill_id = p_skillid;

DBMS_OUTPUT.PUT_LINE('Consultant first name: ' || v_consultant_first_name || ' - Consultant last name: ' || v_consultant_last_name || ' - Skill Description: ' || v_skill_description);
								
COMMIT;
											
EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Warning - An attempt to retrieve a specific data from the database has failed. Look for previous error message.');
WHEN CASE_NOT_FOUND THEN
DBMS_OUTPUT.PUT_LINE('Certification input incorrect. It should be either Y or N .');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('An error has occured. ');

END;
/
show error

SELECT * FROM consultant_skill;

EXEC insert_or_update(100,2,'N');
EXEC insert_or_update(100,2,'N');
EXEC insert_or_update(100,2,'Y');
EXEC insert_or_update(100,2,'ZZZ');
EXEC insert_or_update(101,2,'ZZZZ');
EXEC insert_or_update(102,8,'Y');
EXEC insert_or_update(99999999,8,'Y');
EXEC insert_or_update(104,999999999,'Y');
EXEC insert_or_update(9999999999999999,81231231231123,'Z');
EXEC insert_or_update(9999999999999999,81231231231123,'Y');

SELECT * FROM consultant_skill;


							
				
			